{ lib, pkgs, ... }:

{
  imports = [ ./stylix.nix ];
  config = {
    home-manager.users.nason = ./home.nix;
    users.users.nason = {
      isNormalUser = true;
      home = "/home/nason";
      createHome = true;
      extraGroups = [ "wheel" "disk" "networkmanager" "input" ];
    };
  };
}
