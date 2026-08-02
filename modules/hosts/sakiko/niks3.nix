{ inputs, ... }:
{
  flake.modules.nixos."hosts/sakiko" =
    { config, ... }:
    {
      imports = [ inputs.niks3.nixosModules.niks3-auto-upload ];

      vaultix.secrets.niks3-api-token.file = ../../../secrets/niks3-api-token.age;

      services.niks3-auto-upload = {
        enable = true;
        serverUrl = "https://niks3.idkidknow.com";
        authTokenFile = config.vaultix.secrets.niks3-api-token.path;
      };

      environment.systemPackages = [ inputs.niks3.packages.x86_64-linux.niks3 ];
    };
}
