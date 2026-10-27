{ pkgs }:

let
  setWallpaper = pkgs.writeShellScriptBin "set-wallpaper" ''
    set -euo pipefail
    if [ $# -lt 1 ]; then
      echo "uso: set-wallpaper <caminho-da-imagem>" >&2
      exit 1
    fi
    src="$1"
    if [ ! -f "$src" ]; then
      echo "arquivo não encontrado: $src" >&2
      exit 1
    fi

    dir="$HOME/.config/wallpaper"
    mkdir -p "$dir"
    ${pkgs.imagemagick}/bin/magick "$src" "$dir/current.png"

    ${pkgs.procps}/bin/pkill -x swaybg 2>/dev/null || true
    setsid ${pkgs.swaybg}/bin/swaybg -i "$dir/current.png" -m fill -o "*" >/dev/null 2>&1 &
    disown
    echo "wallpaper atualizado: $src"
  '';
in
{
  screenshotAnnotate = pkgs.writeShellScriptBin "screenshot-annotate" ''
    set -euo pipefail
    dir="$HOME/Imagens/Screenshots"
    mkdir -p "$dir"
    file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - \
      | ${pkgs.swappy}/bin/swappy -f - -o "$file"
  '';

  lockScreen = pkgs.writeShellScriptBin "lock-screen" ''
    exec ${pkgs.swaylock}/bin/swaylock
  '';

  powerMenu = pkgs.writeShellScriptBin "power-menu" ''
    exec ${pkgs.wlogout}/bin/wlogout -b 5
  '';

  clipboardMenu = pkgs.writeShellScriptBin "clipboard-menu" ''
    set -euo pipefail
    ${pkgs.cliphist}/bin/cliphist list \
      | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt-only "Clipboard > " \
      | ${pkgs.cliphist}/bin/cliphist decode \
      | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  powerProfile = pkgs.writeShellScriptBin "power-profile" ''
    set -euo pipefail
    ppc=${pkgs.power-profiles-daemon}/bin/powerprofilesctl

    case "''${1:-menu}" in
      menu)
        case "$($ppc get)" in
          power-saver) atual=0 ;;
          performance) atual=2 ;;
          *)           atual=1 ;;
        esac
        escolha=$(printf '%s\n' "󰌪  Economia" "󰾅  Equilibrado" "󰓅  Desempenho" \
          | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "Energia > " \
              --lines 3 --width 24 --select-index "$atual") || exit 0

        case "$escolha" in
          *Economia)    perfil=power-saver ;;
          *Equilibrado) perfil=balanced ;;
          *Desempenho)  perfil=performance ;;
          *) exit 0 ;;
        esac

        $ppc set "$perfil"
        ${pkgs.libnotify}/bin/notify-send -t 2000 "Modo de energia" "$escolha"
        ;;

      *)
        echo "uso: power-profile [menu]" >&2
        exit 1
        ;;
    esac
  '';

}
