{ pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    efiInstallAsRemovable = true;
  };
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
}
