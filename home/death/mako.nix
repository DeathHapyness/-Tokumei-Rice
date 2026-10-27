{ ... }:

let
  theme = import ./theme.nix;
in
{
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      layer = "overlay";
      font = "${theme.font} 11";
      width = 320;
      height = 110;
      margin = "10";
      padding = "10";
      border-size = 2;
      border-radius = 8;
      background-color = "${theme.bg}ee";
      text-color = theme.fg;
      border-color = theme.blue;
      progress-color = "over ${theme.bgHighlight}";
      default-timeout = 5000;
      ignore-timeout = false;
      icons = true;
      max-icon-size = 48;
      markup = true;

      "urgency=low" = {
        border-color = theme.comment;
      };
      "urgency=critical" = {
        border-color = theme.red;
        default-timeout = 0;
      };
    };
  };
}
