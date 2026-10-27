{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  programs.nix-ld.enable = true;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking + hardening/anonimato
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.networkmanager.wifi.macAddress = "random";
  networking.networkmanager.wifi.scanRandMacAddress = true;
  networking.networkmanager.settings.connectivity.enabled = false;

  networking.nftables.enable = true;
  networking.firewall.enable = true;
  networking.firewall.logRefusedConnections = false;

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.use_tempaddr" = 2; 
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "false"; 
      DNSOverTLS = "opportunistic";
      FallbackDNS = [ "194.242.2.2" "194.242.2.3" ];
    };
  };

  services.tor = {
    enable = true;
    client.enable = true;
  };

  services.mullvad-vpn.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.displayManager.defaultSession = "niri";

  programs.niri.enable = true;

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome xdg-desktop-portal-gtk ];
    config.niri.default = [ "gnome" "gtk" ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; 
  };

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  users.users."death" = {
    isNormalUser = true;
    description = "death";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5F8jqozvjhobLJtVSqrwuWR3S4kuBFjBfjA6kBY0Ga death@nixos"
    ];
  };

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      NoDefaultBookmarks = true;
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://dns.mullvad.net/dns-query";
        Locked = false;
      };
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      HttpsOnlyMode = "enabled";
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    vim
    mullvad-vpn
    tor-browser
    macchanger
    torsocks
    xwayland-satellite 
    tailscale
    docker
    podman
    python3
    gnome-boxes
    go
    jetbrains.goland
    delve
    gopls
    gotools
    golangci-lint
  ];

  services.tailscale.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
