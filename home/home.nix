{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default

    ./zsh.nix
    ./de.nix
    ./music.nix
    ./xdg-mime.nix
  ];

  home.username = "seththecat";
  home.homeDirectory = "/home/seththecat";
  home.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name  = "seth-the-cat";
      user.email = "ty@toliveistofly.com";
      gpg.format = "ssh";
      init.defaultBranch = "main";
    };
  };

  home.packages = with pkgs; [
    kitty
    kdePackages.dolphin
    thunderbird
    keepassxc
    syncthing
    nextcloud-client
    steam
    prismlauncher
    kdePackages.kdenlive

    wl-clipboard

    audacity

    # -- Office / Writing
    obsidian libreoffice-qt6 texstudio texliveFull
    zathura hunspell hunspellDicts.en_US-large
    wordgrinder neovim

    # vesktop
    strawberry

    thunderbird
    zoom-us

    # Archives
    p7zip
    unzip
    unrar
    zip
    gnutar

    # File management
    yazi          # terminal file manager, great with kitty
    trash-cli     # safe rm alternative
    fd            # better find
    ripgrep       # better grep
    tree

    # System monitoring
    btop          # better htop
    nvtopPackages.nvidia  # GPU monitor for your 4060
    smartmontools # disk health (smartctl)
    lm_sensors    # CPU temp

    # Disk usage
    ncdu          # interactive disk usage
    duf           # better df

    # Networking
    curl
    wget
    nmap
    speedtest-cli
    dig           # DNS lookup

    # Media
    ffmpeg
    imagemagick
    mpv           # lightweight video player

    # Misc
    jq            # JSON processor
    fzf           # fuzzy finder
    bat           # better cat
    eza           # better ls
    zoxide        # smarter cd
    wl-clipboard  # wayland clipboard CLI (wl-copy/wl-paste)
    xdg-utils     # xdg-open etc
    file          # identify file types

    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    gpu-screen-recorder
  ];
  
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      waveform
      obs-vkcapture
      obs-move-transition
      obs-backgroundremoval
      advanced-scene-switcher
      obs-pipewire-audio-capture
      
    ];
  };

  
  services.ssh-agent.enable = true;

  services = {
    syncthing.enable = true;
  };
}
