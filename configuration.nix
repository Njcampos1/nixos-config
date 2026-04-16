# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/core/boot.nix
    ./modules/core/network.nix
    ./modules/core/users.nix
    ./modules/desktop/plasma.nix
    ./modules/apps/dev-tools.nix
    ./modules/apps/postgresql.nix
    
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  home-manager.users.njcampos1 = import ./modules/home/home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  system.stateVersion = "25.11"; 
}