{ ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    initrd = {
      availableKernelModules = [
        "thunderbolt"
      ];
      kernelModules = [
        "evdi"
      ];
    };
  };
}
