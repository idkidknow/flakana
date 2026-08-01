{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    let
      # https://github.com/sched-ext/scx/pull/3721
      # track: wait for https://github.com/sched-ext/scx/releases
      patchedRustscheds = pkgs.scx.rustscheds.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./scx-rusty-retained-cpumask.patch ];
      });
    in
    {
      services.scx = {
        enable = true;
        scheduler = "scx_rusty";
        package = pkgs.scx.full.override {
          scx = pkgs.scx // {
            rustscheds = patchedRustscheds;
          };
        };
      };
    };
}
