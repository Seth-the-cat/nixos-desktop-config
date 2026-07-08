{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    meslo-lgs-nf
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      edit   = "sudo -e";
      update = "sudo nixos-rebuild switch --flake ~/nixos-config/.#seththecat";
      hm     = "home-manager switch --flake ~/nixos-config/.#seththecat@seththecat";
      ll  = "eza -la --icons";
      ls   = "eza --icons";
      cat  = "bat";
      cd   = "z";      # zoxide
      rm   = "trash";  # trash-cli safety net
      open = "xdg-open";
    };

    history = {
      size       = 10000;
      path       = "$HOME/.zsh_history";
      ignoreDups = true;
    };

    oh-my-zsh = {
      enable  = true;
      plugins = [ "git" "python" ];
    };

    initContent = ''
      # zsh-nix-shell — keeps zsh working inside nix-shell
      source ${pkgs.fetchFromGitHub {
        owner  = "chisui";
        repo   = "zsh-nix-shell";
        rev    = "v0.8.0";
        sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
      }}/nix-shell.plugin.zsh

      export EDITOR=nvim

      # Powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Atuin
      eval "$(${pkgs.atuin}/bin/atuin init zsh)"
  
      # Zoxide
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

    '';
  };

  # Atuin via home-manager for config management
  programs.atuin = {
    enable = true;
    enableZshIntegration = false; # we do it manually above to control order
  };
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
}
