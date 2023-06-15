{ pkgs, ... }:

{
  imports = [ ./stylix.nix ];
  config = {
    home-manager.users.nason = ./home.nix;
    users.users.nason = {
      isNormalUser = true;
      home = "/home/nason";
      shell = pkgs.zsh;
      createHome = true;
      extraGroups = [ "wheel" "disk" "networkmanager" "input" ];
    };
  };
}
