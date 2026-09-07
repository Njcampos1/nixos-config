{ pkgs, inputs, ... }:

{
  virtualisation.docker.enable = true;

  # Solo la CLI de Antigravity (comando `agy`), sin el IDE/editor gráfico.
  nixpkgs.overlays = [ inputs.antigravity-nix.overlays.default ];

  environment.systemPackages = with pkgs; [
    gh
    python3
    obsidian
    discord
    telegram-desktop
    kdePackages.kate
    google-antigravity-cli
  ];
  programs.firefox.enable = true;
}
