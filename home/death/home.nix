{ config, pkgs, lib, ... }:

let
  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  imports = [
    ./niri.nix
    ./waybar.nix
    ./kitty.nix
    ./fastfetch.nix
    ./wlogout.nix
    ./gtk-qt.nix
    ./lock.nix
    ./bash.nix
    ./fuzzel.nix
    ./mako.nix
  ];

  home.username = "death";
  home.homeDirectory = "/home/death";
  home.stateVersion = "26.05";

  home.packages = with pkgs;
    (builtins.attrValues scripts)
    ++ [
      swaybg
      wl-clipboard
      cliphist
      grim
      slurp
      swappy
      brightnessctl
      playerctl
      pavucontrol
      networkmanagerapplet
      blueman
      polkit_gnome
      prismlauncher
      nwg-look
      zathura 
      obsidian 
      libreoffice-stable
      qalculate-gtk
      vscodium 
      jetbrains.idea 
      jdk21
      torsocks
    ];

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.sessionPath = [ "$HOME/go/bin" ];
}
