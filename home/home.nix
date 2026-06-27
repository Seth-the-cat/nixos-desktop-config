{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
    ./home/zsh.nix
    ./home/de.nix
  ];

  home.username = "seththecat";
  home.homeDirectory = "/home/seththecat";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    kitty
    dolphin
    keepassxc
    syncthing
    nextcloud-client
    steam

    wl-clipboard

    # -- Office / Writing
    obsidian libreoffice-qt6 texstudio texliveFull
    zathura hunspell hunspellDicts.en_US-large
    wordgrinder

    vesktop
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

    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  service = {
    syncthing.enable = true;
  };
}
