{ config, pkgs, lib, ... }:

let
  theme = import ./theme.nix;
in
{
  programs.swaylock = {
    enable = true;
    settings = {
      color = lib.removePrefix "#" theme.bg;
      font = theme.font;
      indicator-radius = 100;
      indicator-thickness = 10;
      ring-color = lib.removePrefix "#" theme.fgGutter;
      ring-ver-color = lib.removePrefix "#" theme.blue;
      ring-wrong-color = lib.removePrefix "#" theme.red;
      ring-clear-color = lib.removePrefix "#" theme.yellow;
      key-hl-color = lib.removePrefix "#" theme.magenta;
      line-color = "00000000";
      inside-color = "00000000";
      text-color = lib.removePrefix "#" theme.fg;
      text-ver-color = lib.removePrefix "#" theme.blue;
      text-wrong-color = lib.removePrefix "#" theme.red;
      separator-color = "00000000";
      fade-in = "0.2";
      ignore-empty-password = true;
      show-failed-attempts = true;
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { timeout = 600; command = "niri msg action power-off-monitors"; resumeCommand = "niri msg action power-on-monitors"; }
    ];
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
      lock = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };
}
