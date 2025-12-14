{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/7acb21f5-c4a7-462a-91db-e1a3611f8525";
      fsType = "ext4";
    };

    "/bin" = {
      device = "/usr/bin";
      fsType = "none";
      options = ["bind"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/84B3-1BC0";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    "/mnt/nas" = {
      device = "192.168.40.11:/volume1/DiskStation54TB";
      fsType = "nfs";
      options = ["rw" "bg" "soft" "tcp" "_netdev"];
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/5c3ee7b1-89ff-4a74-b39f-fac8f15eef99";}];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
