{ config, pkgs, lib, ... }:

let
  theme = import ./theme.nix;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = false; # a barra já é iniciada pelo spawn-at-startup do niri

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 34;
      spacing = 4;
      margin-top = 6;
      margin-left = 10;
      margin-right = 10;

      modules-left = [ "niri/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "group/brightness" "battery" "tray" "custom/power" ];

      "niri/workspaces" = {
        format = "{index}";
      };

      "clock" = {
        format = "  {:%H:%M   %d/%m}";
        tooltip-format = "<big>{:%Y-%m-%d}</big>\n<tt>{calendar}</tt>";
      };

      "pulseaudio" = {
        format = "{icon}  {volume}%";
        format-muted = "  mudo";
        format-icons = {
          default = [ "" "" "" ];
        };
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-click-right = "pavucontrol";
        scroll-step = 5;
      };

      "battery" = {
        interval = 30;
        states = {
          warning = 25;
          critical = 10;
        };
        format = "{icon}  {capacity}%";
        format-charging = "{icon}  {capacity}%";
        format-icons = {
          charging = [ "" "" "" "" "" ];
          default = [ "" "" "" "" "" ];
        };
        on-click = "power-profile menu"; # menu Economia / Equilibrado / Desempenho
      };

      "group/brightness" = {
        orientation = "horizontal";
        drawer = {
          click-to-reveal = true;
          transition-duration = 300;
        };
        modules = [ "backlight" "backlight/slider" ];
      };

      "backlight" = {
        format = "{icon}  {percent}%";
        format-icons = [ "󰃞" "󰃟" "󰃠" ];
        tooltip = false;
      };

      "backlight/slider" = {
        min = 1; # nunca 0, pra tela não apagar
        max = 100;
        orientation = "horizontal";
      };

      "tray" = {
        icon-size = 16;
        spacing = 10;
      };

      "custom/power" = {
        format = "⏻";
        on-click = "power-menu";
        tooltip = false;
      };
    };
  };

  programs.waybar.style = ''
    * {
      font-family: "${theme.font}";
      font-size: 13px;
      min-height: 0;
    }

    window#waybar {
      background: transparent;
    }

    #waybar {
      background-color: ${theme.rgba theme.bgDark "e6"};
      color: ${theme.fg};
      border-radius: 12px;
      border: 1px solid ${theme.fgGutter};
    }

    #workspaces {
      background-color: ${theme.bgHighlight};
      border-radius: 10px;
      margin: 4px 0 4px 6px;
      padding: 0 4px;
    }

    #workspaces button {
      color: ${theme.comment};
      padding: 0 8px;
      border-radius: 8px;
      background: transparent;
    }

    #workspaces button.active {
      color: ${theme.bgDark};
      background-color: ${theme.blue};
    }

    #workspaces button:hover {
      background-color: ${theme.fgGutter};
      color: ${theme.fg};
    }

    #clock,
    #pulseaudio,
    #battery,
    #tray,
    #brightness,
    #custom-power {
      padding: 0 10px;
      margin: 4px 3px;
      background-color: ${theme.bgHighlight};
      border-radius: 10px;
    }

    #clock { color: ${theme.magenta}; }
    #pulseaudio { color: ${theme.green2}; }
    #battery { color: ${theme.yellow}; }
    #battery.warning { color: ${theme.orange}; }
    #battery.critical { color: ${theme.red}; }
    #battery.charging { color: ${theme.green}; }

    #backlight { color: ${theme.yellow}; }

    /* bolinha do brilho */
    #backlight-slider slider {
      min-height: 12px;
      min-width: 12px;
      border-radius: 50%;
      background-color: ${theme.yellow};
      border: none;
      box-shadow: none;
    }
    #backlight-slider trough {
      min-height: 6px;
      min-width: 90px;
      border-radius: 4px;
      background-color: ${theme.fgGutter};
    }
    #backlight-slider highlight {
      border-radius: 4px;
      background-color: ${theme.yellow};
    }

    #custom-power {
      color: ${theme.red};
      margin-right: 6px;
    }
    #custom-power:hover {
      background-color: ${theme.red};
      color: ${theme.bgDark};
    }

    #tray > .passive { opacity: 0.6; }
    #tray > .needs-attention { color: ${theme.red}; }
  '';
}
