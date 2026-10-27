{ lib, ... }:

let
  theme = import ./theme.nix;
  hex = color: lib.removePrefix "#" color;
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "${theme.font}:size=11";
        terminal = "kitty";
        layer = "overlay";
        width = 40;
        horizontal-pad = 20;
        vertical-pad = 16;
        inner-pad = 10;
        lines = 8;
      };
      colors = {
        background = "${hex theme.bg}ee";
        text = hex theme.fg;
        placeholder = hex theme.comment;
        match = hex theme.blue;
        selection = hex theme.bgSelection;
        selection-text = hex theme.fg;
        selection-match = hex theme.blue;
        border = hex theme.blue;
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };
}
