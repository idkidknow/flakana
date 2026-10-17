import cats.effect.ExitCode
import cats.effect.IO
import cats.effect.IOApp
import cats.effect.std.Console
import cats.effect.std.Env
import cats.syntax.all.*
import com.monovore.decline.Command
import com.monovore.decline.Opts
import cps.*
import cps.monads.catsEffect.given
import fs2.Stream
import fs2.io.file.CopyFlag
import fs2.io.file.CopyFlags
import fs2.io.file.Files
import fs2.io.file.Path

object main extends IOApp {
  private val command = Command(
    name = "my",
    header = "my scripts",
  ) {
    Opts.subcommand(
      name = "instantiate-symlink",
      help = "Replace a symbolic link with a copy of its target.",
    ) {
      Opts
        .argument[java.nio.file.Path](metavar = "path")
        .map(path => instantiateSymlink(Path.fromNioPath(path)))
    } orElse Opts.subcommand(
      name = "prune-qq",
      help = "Remove QQ cache directories.",
    ) {
      Opts.unit.as(pruneQQ)
    }
  }

  override def run(args: List[String]): IO[ExitCode] =
    command.parse(args) match {
      case Left(help) if help.errors.isEmpty =>
        IO.println(help.toString).as(ExitCode.Success)
      case Left(help) =>
        Console[IO].errorln(help.toString).as(ExitCode.Error)
      case Right(action) =>
        action.as(ExitCode.Success)
    }
}

def instantiateSymlink(path: Path): IO[Unit] = async[IO] {
  val realPath = Files[IO].realPath(path).await
  Files[IO].copy(realPath, path, CopyFlags(CopyFlag.ReplaceExisting)).await
}

def pruneQQ: IO[Unit] = async[IO] {
  val home =
    Env[IO].get("HOME").await.fold(throw Exception("missing $HOME"))(identity)
  val bases = Files[IO]
    .list(Path(home) / ".config/QQ")
    .filter(_.fileName.toString.startsWith("nt_qq_"))
  val dirs = Stream(
    Path("Emoji/emoji-recv"),
    Path("log"),
    Path("Video"),
    Path("Pic"),
  )
  val prune = for {
    base <- bases
    dir <- dirs
    path = base / "nt_data" / dir
    _ <- Stream.exec(
      Files[IO].deleteRecursively(path).handleError(Console[IO].errorln)
    )
  } yield ()
  prune.compile.drain.await
}
