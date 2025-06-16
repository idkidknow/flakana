source "./options.nu"

$env.config.buffer_editor = "micro"
$env.config.show_banner = false
$env.config.use_kitty_protocol = true

$env.config.datetime_format.table = "%Y-%m-%d %H:%M:%S"

$env.config.filesize.unit = "binary"
$env.config.filesize.precision = 2

$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 1145141
$env.config.history.isolation = true

if ($options.is_arch) {
  # check if there's an Arch Linux package containing the command
  $env.config.hooks.command_not_found = {|cmd_name|
    let pkgs = try {
      (pkgfile --binaries --verbose $cmd_name)
    }
    if ($pkgs | is-empty) {
      return null
    }
    (
      $"(ansi $env.config.color_config.shape_external)($cmd_name)(ansi reset) " +
        $"may be found in the following packages:\n($pkgs)"
    )
  }
}

# direnv
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change | get --ignore-errors PWD | default [] | append {||
    if (which direnv | is-empty) {
        return
    }

    direnv export json | from json | default {} | load-env
}

if ($options.is_wsl) {
  # Avoid to use Windows Path unintentionally
  # ArchWSL: Arch.exe config --append-path false
  # NixOS-WSL: wsl.interop.includePath = false;
  let windows_path = $env.PATH | filter { $in =~ "^/mnt/[a-z]/" }
  $env.PATH = $env.PATH
    | filter { $in !~ "^/mnt/[a-z]/" }
    | prepend ("/mnt/c/Users/ifidk/AppData/Local/Programs/Microsoft VS Code/bin")
}

$env.PATH = $env.PATH
    | prepend "~/.local/bin"
    | uniq

$env.EDITOR = $env.config.buffer_editor

alias l = eza -Hgh --time-style=iso --icons always
alias ll = l -l

use std/dirs

# yazi
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}
