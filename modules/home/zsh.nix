{
  lib,
  pkgs,
  config,
  ...
}: {
  home = {
    file.".p10k.zsh".text = builtins.readFile ../../config/zsh/p10k.zsh;
    packages = with pkgs; [
      zsh-powerlevel10k
    ];
  };

  programs = {
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      initContent = let
        bitawardenSSHSockPath =
          if pkgs.stdenv.isDarwin
          then ''
            ${config.home.homeDirectory}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
          ''
          else ''
            ${config.home.homeDirectory}/.bitwarden-ssh-agent.sock
          '';
      in
        lib.mkMerge [
          (lib.mkBefore ''
            # Powerlevel10k Zsh theme
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          '')
          (lib.mkOrder 550 (builtins.readFile ../../config/zsh/zshrc))
          (
            lib.mkOrder 1000 ''
              export SSH_AUTH_SOCK=${bitawardenSSHSockPath}
            ''
          )
        ];
      oh-my-zsh = {
        enable = true;
        plugins =
          [
            "git"
            "scd"
            "dotenv"
          ]
          # Use ssh-agent on darwin only
          ++ lib.optionals pkgs.stdenv.isDarwin [
            "ssh-agent"
          ];
      };
    };
  };
}
