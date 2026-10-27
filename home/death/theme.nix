# Paleta "Manga Alley" — tirada do ~/Imagens/wallpaper1.jpg (mangá em
# tons de cinza frio). Base = cinzas medidos da imagem; acentos = cores
# bem dessaturadas no mesmo tom, estilo retícula. Usada em todos os programas
# do rice. Mudar aqui muda o tema em todo lugar que importa este arquivo.
let
  hexDigit = {
    "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
    "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
    a = 10; b = 11; c = 12; d = 13; e = 14; f = 15;
    A = 10; B = 11; C = 12; D = 13; E = 14; F = 15;
  };
  hexByte = s: (hexDigit.${builtins.substring 0 1 s}) * 16 + (hexDigit.${builtins.substring 1 1 s});
in
{
  bg = "#1e1f23";
  bgDark = "#17181b";
  bgHighlight = "#2c2d31";
  bgSelection = "#3f4044";
  fg = "#dbdce1";
  fgDark = "#bec1c7";
  fgGutter = "#5c5d62";
  comment = "#7c7c83";
  black = "#141518";
  blue = "#9fa8c0";
  cyan = "#a3b8c2";
  magenta = "#b3a8c4";
  purple = "#9a94b0";
  orange = "#c8a88e";
  yellow = "#d0c49a";
  green = "#a4b89a";
  green2 = "#9cbab2";
  red = "#c98a8e";
  red2 = "#b06a6f";

  font = "JetBrainsMono Nerd Font";

  # GTK (CSS do waybar, wlogout, etc.) não entende a notação #RRGGBBAA de
  # 8 dígitos — dá erro "Junk at end of value". Use `theme.rgba theme.bg
  # "cc"` no lugar de `"${theme.bg}cc"` para cor com transparência.
  rgba = hexColor: alphaHex:
    let
      r = hexByte (builtins.substring 1 2 hexColor);
      g = hexByte (builtins.substring 3 2 hexColor);
      b = hexByte (builtins.substring 5 2 hexColor);
      a = hexByte alphaHex;
    in
    "rgba(${toString r}, ${toString g}, ${toString b}, ${builtins.toJSON (a / 255.0)})";
}
