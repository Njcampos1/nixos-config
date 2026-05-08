{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs;
  [
    gh
    python3
    obsidian
    discord
    telegram-desktop
    kdePackages.kate
    zed-editor
  ];
  programs.firefox.enable = true;
}