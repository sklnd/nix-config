{
  ...
}:
let
  aerospaceConfig = builtins.readFile ../config/aerospace/aerospace.toml;
in
{
  services.aerospace = {
    enable = true;
    settings = builtins.fromTOML aerospaceConfig;
  };
}
