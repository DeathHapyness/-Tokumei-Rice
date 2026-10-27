{ pkgs, theme }:

pkgs.runCommand "tokyonight-wallpaper.png"
  {
    nativeBuildInputs = [ pkgs.imagemagick ];
  }
  ''
    magick -size 2560x1440 radial-gradient:"${theme.bgHighlight}-${theme.bgDark}" \
      -fill none \
      -stroke "${theme.blue}33" -strokewidth 2 -draw "circle 2100,1150 2100,950" \
      -stroke "${theme.blue}22" -strokewidth 2 -draw "circle 2100,1150 2100,850" \
      -stroke "${theme.purple}22" -strokewidth 2 -draw "circle 2100,1150 2100,750" \
      -stroke "${theme.cyan}18" -strokewidth 1 -draw "circle 2100,1150 2100,650" \
      "$out"
  ''
