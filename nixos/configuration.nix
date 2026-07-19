{ config, pkgs, inputs, ... }:
{
  imports = [ inputs.aagl.nixosModules.default ];

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://ezkea.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.systemd-boot.enable = false;
  boot.loader.limine.enable = true;

  # Locale / timezone
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # Set console keyboard to dvorak
  console.keyMap = "dvorak";

  # Networking
  networking.hostName = "seththecat";
  networking.networkmanager.enable = true;

  # Required for Noctalia wifi/bt/power features
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Audio — pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nice"; type = "-"; value = "-19"; }
  ];

  security.polkit.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Display manager — greetd is lightweight and Wayland-native
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # XDG portals (required for Hyprland screen sharing etc)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  # System packages (minimal — most goes in home.nix)
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # User
  users.users.seththecat = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  programs.honkers-railway-launcher.enable = true;
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  services.sshd.enable = true;
  services.tailscale.enable = true;
  services.cloudflare-warp.enable = true;

  services.xremap = {
    enable = true;
    withHypr = true;
    userName = "seththecat";
    yamlConfig = builtins.readFile ./xremap.yml;
  };

  systemd.services.xremap.serviceConfig.BindReadOnlyPaths = [
    "/home/seththecat/Scripts"
  ];

  system.stateVersion = "26.05";
}
