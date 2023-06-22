# A trait for headed boxxen - sway + wayland
{ config, pkgs, lib, nur, ... }:

{

  networking.networkmanager.enable = true;

  programs = {
    dconf.enable = true;
    firefox = {
      enable = true;
    };
  };
  
  fonts = {
    fontconfig.enable = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
      fira-code
      fira-code-symbols
    ];
  };

  environment.systemPackages = with pkgs;
    [
      networkmanager
      sway
      wofi
      swaylock
      swayidle
      kitty
      vim
      qemu
      appgate-sdp
      # xdg stuff
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      # gpu
      glxinfo
      vulkan-tools
      # desktop
      firefox
      ffmpeg
      #neovimConfigured
    ] ++ (if stdenv.isx86_64 then [
      spotify
      chromium
    ] else if stdenv.isAarch64 then
      [ spotify ]
    else
      [ ]);


  environment.sessionVariables = {
   MOZ_ENABLE_WAYLAND = "1";
   XDG_CURRENT_DESKTOP = "sway"; 
   };

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

  powerManagement = {
    cpuFreqGovernor = lib.mkDefault "performance";
    powertop.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = { text = "auth include login"; };
  };

  services = {
    dbus.packages = with pkgs; [ dconf ];
    fwupd.enable = true;
    printing.enable = true;
    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
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

