{
  flake.modules.nixos."hosts/sakiko" =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.daeLanInterfaces;
    in
    {
      options = {
        daeLanInterfaces = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };

      config = {
        services.mihomo = {
          enable = true;
          configFile = "/etc/mihomo/config.yaml";
          webui = pkgs.metacubexd;
        };

        services.dae = {
          enable = true;
          # world-readable in the nix store
          config = ''
            global {
              ${if builtins.length cfg == 0 then "" else "lan_interface: ${lib.join "," cfg}"}
              wan_interface: auto

              log_level: info
              allow_insecure: false
              auto_config_kernel_parameter: true
            }

            node {
              mihomo: 'socks5://127.0.0.1:7890'
            }

            dns {
              upstream {
                googledns: 'tcp+udp://dns.google:53'
                alidns: 'udp://dns.alidns.com:53'
              }
              routing {
                request {
                  # disable ECH to avoid affecting traffic split
                  qtype(https) -> reject
                  fallback: alidns
                }
                response {
                  upstream(googledns) -> accept
                  ip(geoip:private) && !qname(geosite:cn) -> googledns
                  fallback: accept
                }
              }
            }

            group {
              proxy {
                filter: name(mihomo)
                policy: fixed(0)
              }
            }

            routing {
              pname(NetworkManager) -> direct
              pname(mihomo) -> direct
              dip(224.0.0.0/3, 'ff00::/8') -> direct
              dip(geoip:private) -> direct
              dip(geoip:cn) -> direct
              domain(geosite:cn) -> direct

              fallback: proxy
            }
          '';
        };
      };
    };
}
