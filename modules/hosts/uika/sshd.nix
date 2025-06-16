{
  flake.modules.nixOnDroid."hosts/uika" =
    { pkgs, ... }:
    let
      conf = pkgs.writeText "sshd_config" ''
        HostKey /etc/ssh/ssh_host_ed25519_key
        Port 8022
      '';
    in
    {
      supervisord.programs.sshd = {
        command = "${pkgs.writeShellScript "sshd.sh" ''
          set -e
          ${pkgs.openssh}/bin/sshd -D -f ${conf}
        ''}";
      };
    };
}
