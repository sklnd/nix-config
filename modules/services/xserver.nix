{...}: {
  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
      options = "caps:escape";
    };
  };
}
