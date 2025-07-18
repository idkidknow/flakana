{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      # https://github.com/YaLTeR/niri/issues/1962 & https://github.com/YaLTeR/niri/wiki/Nvidia
      environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-niri.json".text = ''
        {
          "rules": [
            {
              "pattern": {
                "feature": "procname",
                "matches": "niri"
              },
              "profile": "Limit Free Buffer Pool In Niri"
            }
          ],
          "profiles": [
            {
              "name": "Limit Free Buffer Pool In Niri",
              "settings": [
                {
                  "key": "GLVidHeapReuseRatio",
                  "value": 0
                }
              ]
            }
          ]
        }
      '';
    };
}
