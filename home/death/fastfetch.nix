{ config, pkgs, lib, ... }:

let
  theme = import ./theme.nix;
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
        color = {
          "1" = "34"; # azul (aprox. theme.blue em ANSI)
          "2" = "38"; # magenta (aprox. theme.magenta em ANSI)
        };
        padding = {
          top = 1;
        };
      };
      display = {
        separator = "  ";
        color = {
          keys = "38;2;122;162;247"; 
          title = "38;2;187;154;247"; 
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        { type = "custom"; format = "WM: niri"; }
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "break"
        "colors"
      ];
    };
  };
}
