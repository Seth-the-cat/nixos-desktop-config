{ pkgs, ... }:
{
  home.packages = with pkgs; [
    reaper
    calf
    lsp-plugins
    x42-plugins
    airwindows-lv2
    distrho-ports
    zam-plugins
  ];

  home.sessionVariables = {
    LV2_PATH = "${pkgs.calf}/lib/lv2:${pkgs.lsp-plugins}/lib/lv2:${pkgs.x42-plugins}/lib/lv2:${pkgs.airwindows-lv2}/lib/lv2:${pkgs.distrho-ports}/lib/lv2";
    LADSPA_PATH = "${pkgs.calf}/lib/ladspa:${pkgs.zam-plugins}/lib/ladspa";
  };

  xdg.configFile."wireplumber/wireplumber.conf.d/99-low-latency.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [ { node.name = "~alsa_output.*" } ]
        actions = {
          update-props = {
            audio.format = "S32LE"
            api.alsa.period-size = 128
            api.alsa.headroom = 0
          }
        }
      }
    ]
    context.properties = {
      default.clock.rate = 48000
      default.clock.quantum = 128
      default.clock.min-quantum = 128
      default.clock.max-quantum = 128
    }
  '';
}
