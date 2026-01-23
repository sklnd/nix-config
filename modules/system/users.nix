{pkgs, ...}: {
  users.users.chris = {
    isNormalUser = true;
    description = "Chris Skalenda";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "plugdev"
    ];
    shell = pkgs.zsh;
  };
}
