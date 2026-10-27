# Config do niri (binds, layout, cores etc.) direto aqui, em Nix puro —
# sem passar por template/render em bash (isso morava em ./rice, que foi
# removido). Pra mudar cor, edite ./theme.nix; pra mudar bind/layout,
# edite o texto abaixo e rode `sudo nixos-rebuild switch --flake
# ~/nixos-config#nixos`.
{ config, lib, ... }:

let
  theme = import ./theme.nix;
  wallpaperCurrent = "${config.home.homeDirectory}/.config/wallpaper/current.png";
  defaultWallpaper = "${config.home.homeDirectory}/Imagens/wallpaper.png";
in
{
  home.file."Imagens/Screenshots/.keep".text = "";

  # Popula o wallpaper "ativo" com o padrão só se ainda não existir —
  # depois disso ele é gerenciado fora do nix store, por set-wallpaper.
  home.activation.seedWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "${wallpaperCurrent}" ]; then
      mkdir -p "$(dirname "${wallpaperCurrent}")"
      cp "${defaultWallpaper}" "${wallpaperCurrent}"
    fi
  '';

  xdg.configFile."niri/config.kdl".text = ''
    // ------------------------------------------------------------------
    // niri config — death@nixos — Tokyo Night
    // gerado via home-manager, não editar direto (edite em
    // ~/nixos-config/home/death/niri.nix e rode `sudo nixos-rebuild switch --flake ~/nixos-config#nixos`)
    // ------------------------------------------------------------------

    input {
        keyboard {
            xkb {
                layout "br"
            }
        }
        touchpad {
            tap
            natural-scroll
        }
        warp-mouse-to-focus
    }

    layout {
        gaps 10
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-color "${theme.blue}"
            inactive-color "${theme.fgGutter}"
        }

        border {
            off
        }

        shadow {
            on
            softness 30
            spread 5
            offset x=0 y=5
            color "#00000070"
        }
    }

    prefer-no-csd

    hotkey-overlay {
        skip-at-startup
    }

    screenshot-path "~/Imagens/Screenshots/captura-%Y-%m-%d-%H-%M-%S.png"

    // janelas: cantos levemente arredondados por padrão
    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
    }

    // Workspaces 100% dinâmicos (jeito nativo do niri): nenhum é fixado
    // no config, então só existem — e só aparecem na waybar — os que
    // você de fato usa, mais um vazio no fim de cada monitor. Índice é
    // posição, não identidade: Mod+N só "pega" depois que o workspace
    // N-1 já existir (ver wiki/Workspaces.md).

    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "swaybg" "-i" "/home/death/.config/wallpaper/current.png" "-m" "fill"
    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "nm-applet" "--indicator"
    spawn-at-startup "blueman-applet"
    spawn-at-startup "polkit-gnome-authentication-agent-1"
    spawn-at-startup "wl-paste" "--type" "text" "--watch" "cliphist" "store"

    binds {
        // --- essenciais ---
        Mod+Return { spawn "kitty"; }
        Mod+Q { close-window; }
        Mod+Space { spawn "fuzzel"; }

        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up    { focus-window-up; }
        Mod+Down  { focus-window-down; }

        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up    { move-window-to-workspace-up; }
        Mod+Shift+Down  { move-window-to-workspace-down; }

        // --- workspaces numerados (1 a 5) ---
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }

        // --- navegação por cima/baixo (pra ir além do 5, ou só passear) ---
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up   { focus-workspace-up; }
        Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }

        // --- overview nativo do niri (visão de cima de todos os workspaces) ---
        Super+O { toggle-overview; }

        // --- layout ---
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+V { toggle-window-floating; }
        Mod+R { switch-preset-column-width; }
        Mod+Comma { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // --- segurança / utilitários ---
        Print { screenshot; }
        Mod+Shift+S { spawn "screenshot-annotate"; }
        Mod+L { spawn "lock-screen"; }
        Mod+Shift+E { spawn "power-menu"; }
        Mod+Shift+V { spawn "clipboard-menu"; }

        // --- teclas de mídia ---
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute        { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86MonBrightnessUp   { spawn "brightnessctl" "set" "5%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "--min-value=1" "set" "5%-"; }
        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioNext { spawn "playerctl" "next"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }

        Mod+Shift+Q { quit; }
    }
  '';
}
