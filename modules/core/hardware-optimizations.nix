{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true; 
  };

  hardware.cpu.intel.updateMicrocode = true;


  services.power-profiles-daemon.enable = false; 
  programs.gamemode.enable = true;
}