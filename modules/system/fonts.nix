{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    monaspace
  ];
}
