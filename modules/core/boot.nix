{ pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    # Eliminamos efiInstallAsRemovable
  };
  
  # CAMBIO CRÍTICO: Debe ser true para que tu Lenovo guarde a NixOS en el menú de arranque
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Es buena práctica indicarle dónde montamos la partición EFI
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
