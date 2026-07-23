{
  inputs,
  config,
  ...
}:
let
  module = config.flake.modules.systemManager."hosts/emilia";
in
{
  flake.systemConfigs.emilia = inputs.system-manager.lib.makeSystemConfig {
    modules = [ module ];
  };
}
