{ config, lib, pkgs, inputs, ... }:

{
  # Intel 13th gen microcode
  hardware.cpu.intel.updateMicrocode = true;

  # CachyOS BORE kernel
  boot.kernelPackages = inputs.nix-cachyos-kernel.packages.${pkgs.system}.linuxPackages_cachyos;

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
