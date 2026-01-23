{pkgs, ...}: {
  users.users.chris = {
    isNormalUser = true;
    description = "Chris Skalenda";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "plugdev"
      "thelounge"
    ];
    shell = pkgs.zsh;
  };
}
