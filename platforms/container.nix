{ lib, ... }:

{
  boot.isContainer = true;
  networking.useDHCP = false;
  services.logrotate.enable = false;
  security.sudo.enable = false;
}
