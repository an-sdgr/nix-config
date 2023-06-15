{ config, pkgs, lib, modulesPath, ... }:

{
  config = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      initrd = {
        availableKernelModules =
          [ "xhci_pci" "thunderbolt" "nvme" "uas" "sd_mod" "rtsx_pci_sdmmc" ];

        kernelModules = [ "kvm-intel" ];

        secrets = { "/crypto_keyfile.bin" = null; };

        # root
        luks.devices."luks-2847bdec-3c0c-436e-bc52-22ed1c0f4bd6".device =
          "/dev/disk/by-uuid/2847bdec-3c0c-436e-bc52-22ed1c0f4bd6";

        # swap
        luks.devices."luks-dc285f5b-54b5-4b64-bba6-ec6dd230d492".device =
          "/dev/disk/by-uuid/dc285f5b-54b5-4b64-bba6-ec6dd230d492";
        luks.devices."luks-dc285f5b-54b5-4b64-bba6-ec6dd230d492".keyFile =
          "/crypto_keyfile.bin";
      };
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/a559fe62-355d-4da9-984f-624811b65353";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/9A01-1DCC";
      fsType = "vfat";
    };

    swapDevices =
      [{ device = "/dev/disk/by-uuid/92ae8fb3-e231-40c5-abd5-23a2b8e068b1"; }];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    networking.hostName = "druid";
    networking.useDHCP = lib.mkDefault true;
    security.polkit.enable = true;

    console.keyMap = "dvorak";
    services.xserver = {
      layout = "us";
      xkbVariant = "dvorak";
      videoDrivers = [ "nvidia" ]; # comment if not using nvidia
    };

    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
      };
    };

    # nvidia drivers
    nixpkgs.config.allowUnfree = true;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    hardware.nvidia.modesetting.enable = true;

    powerManagement.powertop.enable = true;
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.nvidia.powerManagement.enable = true; # experimental

    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;

    # wayland xdg settings
    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };
    };

    security.pam.services.swaylock = { text = "auth inclued login"; };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [ sway ];

  };
}
