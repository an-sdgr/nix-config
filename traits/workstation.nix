# A trait for headed boxxen - sway + wayland
{ config, pkgs, ... }:

{
  config = {

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
        neovimConfigured
      ] ++ (if stdenv.isx86_64 then [
        chromium
        spotify
      ] else if stdenv.isAarch64 then
        [ spotify ]
      else
        [ ]);

    services.printing.enable = true;
  };
}

