{ config, pkgs, lib, ... }:

let
  theme = import ./theme.nix;
in
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 10;
      background_opacity = "0.92";
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";

      foreground = theme.fg;
      background = theme.bg;
      selection_foreground = theme.bg;
      selection_background = theme.fg;
      cursor = theme.fg;

      color0 = theme.black;
      color8 = theme.comment;
      color1 = theme.red;
      color9 = theme.red;
      color2 = theme.green;
      color10 = theme.green;
      color3 = theme.yellow;
      color11 = theme.yellow;
      color4 = theme.blue;
      color12 = theme.blue;
      color5 = theme.magenta;
      color13 = theme.magenta;
      color6 = theme.cyan;
      color14 = theme.cyan;
      color7 = theme.fgDark;
      color15 = theme.fg;
    };
    shellIntegration.enableBashIntegration = false;
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      if [ -t 1 ]; then
        fastfetch
      fi
    '';
  };
}
