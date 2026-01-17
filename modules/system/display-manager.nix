{ ... }:
{
  services.displayManager.gdm.enable = true;

  security.pam.services = {
    gdm.enableGnomeKeyring = true;
    gdm-password.enableGnomeKeyring = true;
  };
}
