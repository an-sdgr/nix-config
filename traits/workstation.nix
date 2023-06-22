# A trait for headed boxxen - sway + wayland
{ config, pkgs, ... }:

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
        xdg-utils
        xdg-desktop-portal
        xdg-desktop-portal-wlr
        #neovimConfigured
      ] ++ (if stdenv.isx86_64 then [
        spotify
      ] else if stdenv.isAarch64 then
        [ spotify ]
      else
      [ ] 
      );

  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-default-browser" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
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

    services.printing.enable = true;
}

