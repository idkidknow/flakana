package myscripts

import cats.effect.IO
import cats.syntax.all.*
import cps.*
import cps.monads.catsEffect.{*, given}
import fs2.Stream
import fs2.io.file.Files
import fs2.io.file.Path
import fs2.io.process.ProcessBuilder
import fs2.io.process.Redirect
import io.circe.generic.auto.*

object Flakana {
  def track(path: Path): IO[Unit] = async[IO] {
    val marker = """\btrack(?: \(([A-Za-z0-9._-]+)\))?:[ \t]*(.*)""".r
    val githubUrl =
      """https://github\.com/([\w.-]+)/([\w.-]+)/(pull|issues)/(\d+)\b""".r

    def report(content: String): IO[Unit] = async[IO] {
      marker.findFirstMatchIn(content).foreach { entry =>
        githubUrl.findPrefixMatchOf(entry.group(2).stripPrefix("[")).foreach {
          url =>
            val owner = url.group(1)
            val repo = url.group(2)
            val kind = url.group(3)
            val number = url.group(4)
            val tag = Option(entry.group(1))
            val unstable = tag.contains("nixos-unstable")
            val nixpkgs = owner.equalsIgnoreCase("NixOS") && repo
              .equalsIgnoreCase("nixpkgs")
            if (kind == "pull" && (tag.isEmpty || (unstable && nixpkgs))) {
              val pr = githubApi[
                (
                    title: String,
                    state: String,
                    merged: Boolean,
                    merge_commit_sha: Option[String],
                )
              ](s"repos/$owner/$repo/pulls/$number").await
              val label = if (unstable) "nixpkgs" else s"$owner/$repo"
              val state = if (pr.merged) "merged" else pr.state
              IO.println(s"$label PR: $number, ${pr.title}").await
              val commit = pr.merge_commit_sha
                .filter(_ => pr.merged) // don't show commit if not merged
              if (unstable) commit.foreach { sha =>
                IO.println(s"commit: $sha").await
              }
              IO.println(s"state: $state").await
              if (unstable) {
                val included = commit
                  .traverse { sha =>
                    githubApi[(status: String)](
                      s"repos/NixOS/nixpkgs/compare/$sha...nixos-unstable?per_page=1"
                    ).map(result =>
                      Set("ahead", "identical").contains(result.status)
                    )
                  }
                  .await
                  .getOrElse(false)
                IO.println(s"nixos-unstable: ${if (included) "✔" else "✘"}")
                  .await
              }
            } else if (kind == "issues" && tag.isEmpty) {
              val issue = githubApi[(title: String, state: String)](
                s"repos/$owner/$repo/issues/$number"
              ).await
              IO.println(s"$owner/$repo issue: $number, ${issue.title}").await
              IO.println(s"state: ${issue.state}").await
            }
        }
      }
    }

    rg(marker.regex, path / "flakana")
      .evalMap { result =>
        IO.println(s"${result.path}:${result.lineNumber}")
          *> IO.println(result.line)
          *> report(result.line)
      }
      .compile
      .drain
      .await
  }

  def setup(path: Path): IO[Unit] = async[IO] {
    ProcessBuilder(
      "jj",
      "git",
      "clone",
      "https://github.com/idkidknow/flakana.git",
      (path / "flakana").toString,
    ).run.await
    ProcessBuilder(
      "jj",
      "git",
      "clone",
      "https://github.com/idkidknow/flakana-priv.git",
      (path / "flakana-priv/private-modules").toString,
    ).run.await
    syncPriv(path).await
  }

  def syncPriv(path: Path): IO[Unit] = async[IO] {
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

  def osBuild(path: Path): IO[Path] = asyncScope[IO] {
    val tempDir = Files[IO].tempDirectory.await
    val host = hostname.await
    val pathPriv = path / "flakana-priv"
    val outLink = tempDir / "result"
    ProcessBuilder(
      "nom",
      "build",
      s"""$pathPriv#nixosConfigurations."$host".config.system.build.toplevel""",
      "--out-link",
      outLink.toString,
    ).run.await
    val out = Files[IO].realPath(outLink).await
    ProcessBuilder("dix", "/run/current-system", out.toString).run.await
    out
  }
}
