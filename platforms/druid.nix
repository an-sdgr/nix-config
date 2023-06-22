{ config, pkgs, lib, modulesPath, ... }:

{
  # druid is a x86_64 intel laptop with nvidia graphics
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  config = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        systemd-boot.configurationLimit = 5;
        efi.canTouchEfiVariables = true;
      };

      kernelParams = [
        "acpi_osi=Linux"
        "pcie_aspm=force"
        "drm.vblankoffdelay=1"
        "mem_sleep_default=deep"
        "i915.enable_psr=0"
      ];

      initrd = {
        availableKernelModules =
          [ "xhci_pci" "thunderbolt" "nvme" "uas" "sd_mod" "rtsx_pci_sdmmc" ];

        kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "kvm-intel" ];

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

    environment.systemPackages = with pkgs; [
      intel-gmmlib
      mesa.drivers
      egl-wayland
    ];
    networking.hostName = "druid";
    networking.useDHCP = lib.mkDefault true;
    console = {
      keyMap = "dvorak";
      earlySetup = true;
      font = "ter-i32b";
      packages = with pkgs; [ terminus_font ];
    };

    services = {
      xserver = {
        layout = "us";
        xkbVariant = "dvorak";
        videoDrivers = [ "nvidia" ]; # comment if not using nvidia
      };

      fstrim.enable = true;
      fprintd = {
        enable = true;
      };
    };

    hardware = {
      cpu.intel.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
        
        nvidia = {
        modesetting.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        open = true;
        nvidiaSettings = true;
        # https://github.com/NixOS/nixos-hardware/issues/348#issuecomment-997123102
        nvidiaPersistenced = true;
        powerManagement = {
          enable = true;
          finegrained = true;
        };

        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };

          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        setLdLibraryPath = true;
        extraPackages = with pkgs; [
          vaapiIntel
          vaapiVdpau
          libvdpau-va-gl
          intel-media-driver
        ];
      };
    };

    # nvidia drivers
    nixpkgs.config.allowUnfree = true;

  };
}
