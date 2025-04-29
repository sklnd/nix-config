{ nvim, host, ... }:
{
  environment.systemPackages = [
    nvim.packages.${host.hostPlatform}.default

  ];

  environment.shellAliases.vim = "nvim";
}
