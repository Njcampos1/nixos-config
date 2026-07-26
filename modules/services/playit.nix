# modules/services/playit.nix
{ config, lib, ... }:

{
  services.playit = {
    enable = true;
    secretPath = "/etc/nixos/secrets/playit-secret.toml";
  };

  # Evita que arranque solo al iniciar el sistema
  systemd.services.playit.wantedBy = lib.mkForce [ ];
}
