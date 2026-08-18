# /etc/nixos/configuration.nix
{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./modules/core/boot.nix
    ./modules/core/network.nix
    ./modules/core/users.nix
    ./modules/core/hardware-optimizations.nix
    ./modules/desktop/plasma.nix
    ./modules/apps/dev-tools.nix
    ./modules/apps/postgresql.nix
    ./modules/apps/gui-apps.nix
    ./modules/desktop/hyprland.nix
    ./modules/apps/minecraft-client.nix
    ./modules/services/minecraft-server.nix
    ./modules/services/playit.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    libuuid # Útil para herramientas de Node.js
    libunwind # Útil para depuración y lenguajes compilados
  ];

  # Paquetes a nivel de sistema para la indexación y utilidades del entorno gráfico.
  environment.systemPackages = with pkgs; [
    desktop-file-utils # Provee 'update-desktop-database' para refrescar asociaciones Mime
    xdg-utils # Provee herramientas estándar como 'xdg-open'
  ];
  # ────────────────────────────────────────────────

  home-manager.users.njcampos1 = import ./modules/home/home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.backupFileExtension = "old";

  system.stateVersion = "25.11";
}
