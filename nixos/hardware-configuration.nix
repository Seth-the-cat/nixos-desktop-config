{ config, lib, pkgs, inputs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/292b5d23-054d-493c-a708-100323349b22";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/292b5d23-054d-493c-a708-100323349b22";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/292b5d23-054d-493c-a708-100323349b22";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/292b5d23-054d-493c-a708-100323349b22";
    fsType = "btrfs";
    options = [ "subvol=@var" "compress=zstd" "noatime" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/292b5d23-054d-493c-a708-100323349b22";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" "noatime" ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/292b5d23-054d-493c-a708-100323349b22";
    fsType = "btrfs";
    options = [ "subvol=@snapshots" "compress=zstd" "noatime" ];
  };

  fileSystems."/home/seththecat/Nextcloud" = {
    device = "/dev/disk/by-uuid/292b5d23-054d-493c-a708-100323349b22";
    fsType = "btrfs";
    options = [ "subvol=@nextcloud" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/087A-B78F";
    fsType = "vfat";
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/1f622fab-9fd2-417c-9de6-7632695402c0";
  }];
  # Intel 13th gen microcode
  hardware.cpu.intel.updateMicrocode = true;

  # CachyOS BORE kernel
  boot.kernelPackages = pkgs.linuxPackagesFor (inputs.nix-cachyos-kernel.packages.${pkgs.stdenv.hostPlatform.system}.linux-cachyos-rt-bore);

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "split_lock_detect=off"
  ];

  boot.blacklistedKernelModules = [ "nouveau" ];

  # NVIDIA RTX 4060
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
