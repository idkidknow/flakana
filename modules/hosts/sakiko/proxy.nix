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
      tailscaleSocksPort = 1055;
    in
    {
      options = {
        daeLanInterfaces = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };

      config = {
        services.tailscale = {
          enable = true;
          interfaceName = "userspace-networking";
          openFirewall = false;
          extraDaemonFlags = [ "--socks5-server=127.0.0.1:${toString tailscaleSocksPort}" ];
          extraSetFlags = [
            "--accept-dns=false"
            "--accept-routes=false"
            "--netfilter-mode=off"
          ];
        };

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
              tailscale: 'socks5://127.0.0.1:${toString tailscaleSocksPort}'
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
              tailnet {
                filter: name(tailscale)
                policy: fixed(0)
              }
            }

            routing {
              pname(NetworkManager) -> direct
              pname(mihomo) -> direct
              pname(tailscaled) -> direct
              dip(224.0.0.0/3, 'ff00::/8') -> direct
              dip(100.64.0.0/10, 'fd7a:115c:a1e0::/48') -> tailnet
              dip(geoip:private) -> direct
              dip(geoip:cn) -> direct
              domain(geosite:cn) -> direct

              fallback: proxy
            }
          '';
        };

        systemd.services.dae = {
          after = [ "tailscaled.service" ];
          wants = [ "tailscaled.service" ];
        };
      };
    };
}
