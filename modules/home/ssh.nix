# /etc/nixos/modules/home/ssh.nix
{ config, pkgs, ... }:

let

  secrets = if builtins.pathExists ./azure-ip.nix 
            then import ./azure-ip.nix 
            else { azure_ip = "0.0.0.0"; }; 
in

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      "azure-server" = {
        hostname = secrets.azure_ip;
        user = "azureuser";
        identityFile = "~/.ssh/keys/upper-key.pem";
        identitiesOnly = true;
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "njcampos1";
        email = "njcampos1@uc.cl"; 
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}