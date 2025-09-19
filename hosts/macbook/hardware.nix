{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "firewire_ohci"
    "usbhid"
    "sd_mod"
    "sr_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/59c59bcf-7a09-4cae-b020-b885858279a7";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/59c59bcf-7a09-4cae-b020-b885858279a7";
    fsType = "btrfs";
    options = [ "subvol=@nix" ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/59c59bcf-7a09-4cae-b020-b885858279a7";
    fsType = "btrfs";
    options = [ "subvol=@snapshots" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/59c59bcf-7a09-4cae-b020-b885858279a7";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9E79-1736";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/mnt/nas" = {
    device = "192.168.40.11:/volume1/DiskStation54TB";
    fsType = "nfs";
  };

  swapDevices = [ ];

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
