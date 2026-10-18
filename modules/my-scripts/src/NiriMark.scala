package myscripts

import cats.effect.IO
import cats.effect.Resource
import cats.effect.std.Console
import cats.effect.std.Env
import cats.effect.std.MapRef
import cats.syntax.all.*
import com.comcast.ip4s.UnixSocketAddress
import cps.*
import cps.monads.catsEffect.{*, given}
import fs2.Chunk
import fs2.io.file.Files
import fs2.io.file.Path
import fs2.io.net.Network
import fs2.io.net.Socket
import fs2.io.net.SocketOption
import io.circe.Json
import io.circe.generic.auto.*
import io.circe.parser.decode
import io.circe.parser.parse
import io.circe.syntax.*

import java.nio.charset.StandardCharsets
import scala.concurrent.duration.*

object NiriMark {
  enum Op {
    case Mark(name: String)
    case Focus(name: String)
  }

  private def getNiriMarkSocketPath: IO[Path] = async[IO] {
    Env[IO].get("NIRI_MARK_SOCKET").await.map(Path(_)).getOrElse {
      val niriSocketPath = Path(ensureEnv("NIRI_SOCKET").await)
      niriSocketPath.normalize.parent.getOrElse(
        Path("/tmp")
      ) / s"${niriSocketPath.fileName.toString}-niri-mark.sock"
    }
  }

  private def writeLine(socket: Socket[IO], str: String): IO[Unit] =
    socket.write(
      Chunk.array((str + '\n').getBytes(StandardCharsets.UTF_8))
    )

  private def readLine(socket: Socket[IO]): IO[String] =
    socket.reads
      .through(fs2.text.utf8.decode)
      .through(fs2.text.lines)
      .head
      .compile
      .onlyOrError

  final class NiriException(message: String) extends RuntimeException(message)

  private def callNiri(socketPath: Path, request: Json): IO[Json] =
    asyncScope[IO] {
      val socket =
        Network[IO].connect(UnixSocketAddress(socketPath.toString)).await
      writeLine(socket, request.noSpaces).await
      val response = parse(readLine(socket).await).pure[IO].rethrow.await
      response.hcursor.get[String]("Err").toOption.foreach { err =>
        IO.raiseError(NiriException(err)).await
      }
      response.hcursor.get[Json]("Ok").pure[IO].rethrow.await
    }

  private def mark(
      marks: MapRef[IO, String, Option[BigInt]],
      niriSocketPath: Path,
      name: String,
  ): IO[Unit] = async[IO] {
    val json = callNiri(niriSocketPath, Json.fromString("FocusedWindow")).await
    val window = json.hcursor
      .get[Option[(id: BigInt)]]("FocusedWindow")
      .pure[IO]
      .rethrow
      .await
    window.foreach { curr =>
      marks(name).update {
        case Some(prevId) if prevId == curr.id => None
        case _ => Some(curr.id)
      }.await
    }
  }

  private def focus(
      marks: MapRef[IO, String, Option[BigInt]],
      niriSocketPath: Path,
      name: String,
  ): IO[Unit] = async[IO] {
    marks(name).get.await.foreach { id =>
      val action = (Action = (FocusWindow = (id = id))).asJson
      callNiri(niriSocketPath, action).void.await
    }
  }

  def daemon: IO[Unit] = asyncScope[IO] {
    val niriSocketPath = Path(ensureEnv("NIRI_SOCKET").await)
    val niriMarkSocketPath = getNiriMarkSocketPath.await

    val marks = MapRef.ofConcurrentHashMap[IO, String, BigInt]().await

    val server = Network[IO]
      .bind(
        UnixSocketAddress(niriMarkSocketPath.toString),
        List(
          SocketOption.unixSocketDeleteOnClose(false)
        ), // If true, FS2 will remove the socket file even when it fails to bind. Why ???
      )
      .flatMap { server =>
        Resource.make(IO.pure(server)) { _ =>
          Files[IO].deleteIfExists(niriMarkSocketPath).void
        }
      }
      .await

    IO.println(niriMarkSocketPath).await

    server.accept
      .evalMap { socket =>
        val handle = async[IO] {
          val op = decode[Op](readLine(socket).await).pure[IO].rethrow.await
          op match {
            case Op.Mark(name) => mark(marks, niriSocketPath, name).await
            case Op.Focus(name) => focus(marks, niriSocketPath, name).await
          }
        }.timeout(5.seconds)
        handle.attempt
          .flatTap {
            case Left(err) => Console[IO].errorln(err)
            case _ => ().pure[IO]
          }
          .flatMap { either =>
            writeLine(socket, either.leftMap(_.toString).asJson.noSpaces)
              .timeout(5.seconds)
          }
          .handleErrorWith(Console[IO].errorln)
      }
      .compile
      .drain
      .await
  }

  object Client {
    private def request(op: Op): IO[Unit] = asyncScope[IO] {
      val socketPath = getNiriMarkSocketPath.await
      val socket =
        Network[IO].connect(UnixSocketAddress(socketPath.toString)).await
      writeLine(socket, op.asJson.noSpaces).await
      val response = decode[Either[String, Unit]](readLine(socket).await)
        .pure[IO]
        .rethrow
        .await
      response.leftMap(RuntimeException(_)).pure[IO].rethrow.await
    }.timeout(10.seconds)

    def mark(name: String): IO[Unit] = request(Op.Mark(name))
    def focus(name: String): IO[Unit] = request(Op.Focus(name))
  }
}
