{ config, pkgs, ... }:

{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;   # run as systemd user service

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = "/home/seththecat/Pictures/wallpaper.png";
      };

      # Recommended when using systemd service
      launch_apps_as_systemd_services = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # Don't use settings = { }; manage config as a raw lua file instead
  };

  # Drop in your hyprland.lua as a managed file
  xdg.configFile."hypr/hyprland.lua" = {
    source = ./hyprland.lua;
    force = true;
  };
}

