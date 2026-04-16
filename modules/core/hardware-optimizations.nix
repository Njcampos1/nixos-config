{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true; 
  };

  services.power-profiles-daemon.enable = false; 
  programs.gamemode.enable = true;
}