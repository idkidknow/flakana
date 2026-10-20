package myscripts

import cats.effect.IO
import cats.syntax.all.*
import cps.*
import cps.monads.catsEffect.{*, given}
import fs2.Stream
import fs2.io.file.Path
import fs2.io.process.ProcessBuilder
import fs2.io.process.Redirect

object Flakana {
  def setup(pathOpt: Option[Path]): IO[Unit] = async[IO] {
    val path = pathOpt.getOrElse(home.await)
    ProcessBuilder(
      "jj",
      "git",
      "clone",
      "https://github.com/idkidknow/flakana.git",
      (path / "flakana").toString,
    ).inheritStdio.spawn[IO].use(_.exitValue).void.await
    ProcessBuilder(
      "jj",
      "git",
      "clone",
      "https://github.com/idkidknow/flakana-priv.git",
      (path / "flakana-priv/private-modules").toString,
    ).inheritStdio.spawn[IO].use(_.exitValue).void.await
    syncPriv(pathOpt).await
  }

  def syncPriv(pathOpt: Option[Path]): IO[Unit] = async[IO] {
    val path = pathOpt.getOrElse(home.await)
    val src = path / "flakana"
    val dst = path / "flakana-priv"
    val files = ProcessBuilder("jj", "file", "list", "-T", "path ++ \"\\0\"")
      .withWorkingDirectory(src)
      .spawn[IO]
      .use { proc =>
        proc.stdout
          .split(_ == 0.toByte)
          .filter(_.nonEmpty)
          .flatMap { chunk =>
            Stream.chunk(chunk).covary[IO].through(fs2.text.utf8.decode)
          }
          .map(src.resolve)
          .compile
          .to(Set)
      }
      .await
    val dirs = files.flatMap { file =>
      Iterator.unfold(file.parent) {
        case Some(curr) if curr.startsWith(src) => Some((curr, curr.parent))
        case _ => None
      }
    } - src

    def escape(str: String): String = {
      val existsWildcard = str.exists {
        case '*' | '?' | '[' => true
        case _ => false
      }
      if (!existsWildcard) str
      else
        str.flatMap {
          case '\\' => "\\\\"
          case ch @ ('*' | '?' | '[') => s"\\$ch"
          case ch => ch.toString
        }
    }

    val preserveRules = Seq(
      "P /private-modules/***",
      "H /private-modules/***",
    )
    val dirRules =
      dirs.filterNot(_.startsWith(src / "private-modules")).toSeq.map { path =>
        val relPath = src.relativize(path).toString
        s"+ /${escape(relPath)}/"
      }
    val fileRules =
      files.filterNot(_.startsWith(src / "private-modules")).toSeq.map { path =>
        val relPath = src.relativize(path).toString
        s"+ /${relPath}"
      }
    val rules = preserveRules ++ dirRules ++ fileRules ++ Seq("- *")

    ProcessBuilder(
      "rsync",
      "-a",
      "--delete",
      "--delete-excluded",
      "--prune-empty-dirs",
      "--from0",
      "--filter=. -",
      "--info=progress2",
      s"$src/",
      s"$dst/",
    )
      .withStdin(Redirect.Pipe)
      .withStdout(Redirect.Inherit)
      .withStderr(Redirect.Inherit)
      .spawn[IO]
      .useOn { proc =>
        val stdin = Stream
          .emits(rules)
          .covary[IO]
          .map(_ + '\u0000')
          .through(fs2.text.utf8.encode)
          .through(proc.stdin)
          .compile
          .drain
        val (_, exitValue) = (stdin, proc.exitValue).parTupled.await
        IO.println(s"rsync: exit $exitValue")
      }
      .await
  }
}
