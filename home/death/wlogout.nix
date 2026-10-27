{ config, pkgs, lib, ... }:

let
  theme = import ./theme.nix;
in
{
  home.packages = [ pkgs.wlogout ];

  xdg.configFile."wlogout/layout.json".text = builtins.toJSON [
    { label = "lock"; action = "lock-screen"; text = "  Bloquear"; keybind = "l"; }
    { label = "logout"; action = "niri msg action quit"; text = "  Sair"; keybind = "e"; }
    { label = "suspend"; action = "systemctl suspend"; text = "  Suspender"; keybind = "s"; }
    { label = "reboot"; action = "systemctl reboot"; text = "  Reiniciar"; keybind = "r"; }
    { label = "shutdown"; action = "systemctl poweroff"; text = "  Desligar"; keybind = "p"; }
  ];

  xdg.configFile."wlogout/style.css".text = ''
    * {
      font-family: "${theme.font}";
      font-size: 16px;
      background-image: none;
    }

    window {
      background-color: ${theme.rgba theme.bg "cc"};
    }

    button {
      color: ${theme.fg};
      background-color: ${theme.bgHighlight};
      border: 2px solid ${theme.fgGutter};
      border-radius: 16px;
      margin: 10px;
      padding: 20px;
    }

    button:hover,
    button:focus {
      border-color: ${theme.blue};
      background-color: ${theme.bgSelection};
    }

    button#shutdown:hover { border-color: ${theme.red}; }
    button#reboot:hover { border-color: ${theme.orange}; }
    button#suspend:hover { border-color: ${theme.yellow}; }
    button#logout:hover { border-color: ${theme.magenta}; }
    button#lock:hover { border-color: ${theme.green}; }
  '';
}
