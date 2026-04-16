{ pkgs, ... }:

{

  programs.zsh.enable = true;

  users.users.njcampos1 = {
    isNormalUser = true;
    description = "Nestor Campos";
    extraGroups = [ "networkmanager" "wheel" "docker" ];


    shell = pkgs.zsh;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };
}
