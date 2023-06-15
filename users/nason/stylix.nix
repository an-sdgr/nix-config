# Configuration for Stylix
# https://github.com/danth/stylix

{ pkgs, ... }:

with import <nixpkgs> { };

{
  stylix = {
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/7p/wallhaven-7pw1we.jpg";
      sha256 = "sha256-yVvk44IG9QbI8neIjIPgEQ2m6HqP1VyWJ5dlfcN3kRo=";
    };

    # schemes from https://github.com/tinted-theming/base16-schemes
    # comment this line for generative schemes based on the wallpaper image
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";

    fonts = {
      serif = {
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      };

      sansSerif = {
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      };

      monospace = {
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      };

      emoji = {
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      };

      sizes = {
        applications = 13;
        desktop = 12;
      };
    };
  };
}

