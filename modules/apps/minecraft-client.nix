{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    prismlauncher # launcher, maneja Java y perfiles por instancia
    temurin-bin-25 # Java 21, requerido por versiones recientes de MC
    mcrcon
  ];
}
