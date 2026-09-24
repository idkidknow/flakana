{ lib, ... }:
{
  options.priv = {
    email = lib.mkOption {
      type = lib.types.str;
      default = "user@example.com";
    };

    domain =
      let
        mkDomainOption =
          name:
          lib.mkOption {
            type = lib.types.str;
            default = "${name}.example.com";
          };
      in
      {
        root = mkDomainOption "root";
        searx = mkDomainOption "searx";
        reposilite = mkDomainOption "reposilite";
        tieba-cloud-sign = mkDomainOption "tieba-cloud-sign";
        alist = mkDomainOption "alist";
        vaultwarden = mkDomainOption "vaultwarden";
        static = mkDomainOption "static";
        kavita = mkDomainOption "kavita";
        forgejo = mkDomainOption "forgejo";
      };
  };
}
