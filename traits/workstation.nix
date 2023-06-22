# A trait for headed boxxen - sway + wayland
{ config, pkgs, lib, ... }:

{

  networking.networkmanager.enable = true;

  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [ dconf ];

  hardware.opengl.driSupport = true;

  fonts.fontconfig.enable = true;
  fonts.enableDefaultFonts = true;
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    jetbrains-mono
    fira-code
    fira-code-symbols
  ];

  environment.systemPackages = with pkgs;
    [
      networkmanager
      sway
      wofi
      swaylock
      swayidle
      kitty
      firefox
      vim
      qemu
      appgate-sdp
      # xdg stuff
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      # gpu
      glxinfo
      #neovimConfigured
    ] ++ (if stdenv.isx86_64 then [
      spotify
      chromium
    ] else if stdenv.isAarch64 then
      [ spotify ]
    else
      [ ]);

  # wayland xdg settings
  xdg = {
    mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-default-browser" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };

    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  security.polkit.enable = true;
  security.pam.services.swaylock = { text = "auth include login"; };

  services.fwupd.enable = true;
  services.fprintd.enable = true;
  services.printing.enable = true;
  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 5;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };

      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

}

