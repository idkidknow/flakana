package myscripts

import cats.effect.ExitCode
import cats.effect.IO
import cats.effect.IOApp
import cats.effect.std.Console
import cats.effect.std.Env
import cats.syntax.all.*
import com.monovore.decline.Command
import com.monovore.decline.Opts
import cps.*
import cps.monads.catsEffect.{*, given}
import fs2.Stream
import fs2.io.file.CopyFlag
import fs2.io.file.CopyFlags
import fs2.io.file.Files
import fs2.io.file.Path
import fs2.io.process.ProcessBuilder
import fs2.io.process.Redirect

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
    } orElse Opts.subcommand(
      name = "flakana",
      help = "Manage flakana repositories.",
    ) {
      val path = Opts
        .argument[java.nio.file.Path](metavar = "path")
        .map(Path.fromNioPath)
        .orNone

      Opts.subcommand(
        name = "setup",
        help = "Set up flakana (default path: $HOME).",
      ) {
        path.map(Flakana.setup)
      } orElse Opts.subcommand(
        name = "sync-priv",
        help = "Sync flakana into flakana-priv (default path: $HOME).",
      ) {
        path.map(Flakana.syncPriv)
      }
    } orElse Opts.subcommand(
      name = "niri-mark",
      help = "Mark and focus niri windows.",
    ) {
      val name = Opts.argument[String](metavar = "name")

      Opts.subcommand(
        name = "daemon",
        help = "Run the niri mark daemon.",
      ) {
        Opts.unit.as(NiriMark.daemon)
      } orElse Opts.subcommand(
        name = "mark",
        help = "Toggle a mark on the focused window.",
      ) {
        name.map(NiriMark.Client.mark)
      } orElse Opts.subcommand(
        name = "focus",
        help = "Focus the window with the given mark.",
      ) {
        name.map(NiriMark.Client.focus)
      }
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

def ensureEnv(name: String): IO[String] =
  Env[IO].get(name).map(_.toRight(Exception(s"missing ${"$"}$name"))).rethrow

def home: IO[Path] = ensureEnv("HOME").map(Path(_))

def instantiateSymlink(path: Path): IO[Unit] = async[IO] {
  val realPath = Files[IO].realPath(path).await
  Files[IO].copy(realPath, path, CopyFlags(CopyFlag.ReplaceExisting)).await
}

def pruneQQ: IO[Unit] = async[IO] {
  val bases = Files[IO]
    .list(home.await / ".config/QQ")
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
