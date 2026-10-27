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
      # utilitários wayland / niri
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

      # aparência
      nwg-look

      # produtividade / faculdade
      zathura # leitor de PDF
      obsidian # notas
      libreoffice-stable
      qalculate-gtk

      # dev
      vscodium # editor do dia a dia (VS Code sem telemetria da MS)
      jetbrains.idea # IntelliJ IDEA (Java) — idea-oss/Community está descontinuado e inseguro
      jdk21

      # segurança / rede
      torsocks
    ];

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Binários instalados com `go install` vão pra ~/go/bin.
  home.sessionPath = [ "$HOME/go/bin" ];
}
