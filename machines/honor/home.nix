_: {
  home = {
    username = "chris.skalenda";
    homeDirectory = "/Users/chris.skalenda";
  };

  programs = {
    git.settings.user.email = "chris.skalenda@joinhonor.com";
    jujutsu.settings.user.email = "chris.skalenda@joinhonor.com";
    gpg.enable = true;
    zsh = {
      initExtra = ''
        source $HOME/.h4.zshrc
      '';

      shellAliases = {
        "h" = "honor";
        "sso" = "aws-vault exec prod-write";
        "sso-deploy" = "aws-vault exec deploy";
      };
    };
  };
}
