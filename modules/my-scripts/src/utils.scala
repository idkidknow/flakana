package myscripts

import cats.effect.IO
import cats.effect.std.Env
import cats.syntax.all.*
import fs2.Stream
import fs2.io.file.Path
import fs2.io.process.ProcessBuilder
import fs2.io.process.Redirect
import io.circe.Decoder
import io.circe.derivation.Configuration
import io.circe.derivation.ConfiguredDecoder
import io.circe.parser.decode

extension (pb: ProcessBuilder) {
  def call: IO[String] =
    pb.withStderr(Redirect.Inherit).withStdout(Redirect.Pipe).spawn[IO].use {
      proc =>
        val output = proc.stdout.through(fs2.text.utf8.decode).compile.string
        (output, proc.exitValue).parTupled.flatMap { case (text, exitCode) =>
          if (exitCode == 0) text.pure[IO]
          else {
            val commandLine = pb.command :: pb.args
            IO.raiseError(RuntimeException(s"$commandLine: exit $exitCode"))
          }
        }
    }

  def run: IO[Unit] = pb.inheritStdio.spawn[IO].use { proc =>
    proc.exitValue.flatMap {
      case 0 => ().pure[IO]
      case exitCode =>
        val commandLine = pb.command :: pb.args
        IO.raiseError(RuntimeException(s"$commandLine: exit $exitCode"))
    }
  }
}

def ensureEnv(name: String): IO[String] =
  Env[IO].get(name).map(_.toRight(Exception(s"missing ${"$"}$name"))).rethrow

def home: IO[Path] = ensureEnv("HOME").map(Path(_))

def hostname: IO[String] = ProcessBuilder("hostname").call.map(_.trim)

def githubApi[A: Decoder](endpoint: String): IO[A] =
  ProcessBuilder("gh", "api", "--hostname", "github.com", endpoint).call
    .flatMap { result =>
      decode[A](result).pure[IO].rethrow
    }

final case class RgMatch(path: Path, lineNumber: Long, line: String)

def rg(pattern: String, path: Path): Stream[IO, RgMatch] = {
  given Configuration = Configuration.default
    .withDiscriminator("type")
    .withSnakeCaseConstructorNames
    .withSnakeCaseMemberNames

  final case class Text(text: String) derives ConfiguredDecoder

  final case class MatchData(path: Text, lineNumber: Long, lines: Text)
      derives ConfiguredDecoder

  enum Event derives ConfiguredDecoder {
    case Match(data: MatchData)
    case Begin, End, Context, Summary
  }

  Stream
    .resource(
      ProcessBuilder(
        "rg",
        "--json",
        "--color",
        "never",
        pattern,
        "--",
        path.toString,
      )
        .withStderr(Redirect.Inherit)
        .spawn[IO]
    )
    .flatMap { proc =>
      val matches = proc.stdout
        .through(fs2.text.utf8.decode)
        .through(fs2.text.lines)
        .filter(_.nonEmpty)
        .evalMap(line => decode[Event](line).pure[IO].rethrow)
        .collect { case Event.Match(data) =>
          RgMatch(
            Path(data.path.text),
            data.lineNumber,
            data.lines.text.stripSuffix("\n").stripSuffix("\r"),
          )
        }
      val checkExit = Stream
        .eval(proc.exitValue.flatMap { exitCode =>
          if (exitCode == 0 || exitCode == 1) IO.unit // found or not found
          else IO.raiseError(RuntimeException(s"rg: exit $exitCode"))
        })
        .drain
      matches ++ checkExit
    }
}
