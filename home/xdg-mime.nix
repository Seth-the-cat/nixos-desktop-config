{ configs, ...}:
{
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "yazi.desktop" ];
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      };
    };
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "kitty.desktop" ]; 
      };
    };
  };
}
