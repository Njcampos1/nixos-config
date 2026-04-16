{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs;
  [
    vscode
    git
    gh
    python3
    obsidian
    discord
    telegram-desktop
    kdePackages.kate
  ];
  programs.firefox.enable = true;
}