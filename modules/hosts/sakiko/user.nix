{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      users.groups.input = { };
      users.users.idkana = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "input"
        ];
      };
    };
}
