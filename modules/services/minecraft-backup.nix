# modules/services/minecraft-backup.nix
{ pkgs, ... }:

let
  backupScript = pkgs.writeShellScript "minecraft-backup.sh" ''
    BACKUP_DIR="/home/njcampos1/mc-backups"
    BACKUP_FILE="$BACKUP_DIR/backup_latest.tar.gz"

    mkdir -p "$BACKUP_DIR"

    # Pase lo que pase (\u00e9xito o error), siempre reactiva el autosave al salir
    trap 'mcrcon -H localhost -P 25575 -p 7752 save-on' EXIT

    mcrcon -H localhost -P 25575 -p 7752 save-all
    mcrcon -H localhost -P 25575 -p 7752 save-off

    # Solo incluye las carpetas de dimensiones que realmente existen
    cd /var/lib/minecraft-server
    DIRS="world"
    [ -d world_nether ] && DIRS="$DIRS world_nether"
    [ -d world_the_end ] && DIRS="$DIRS world_the_end"

    # Toleramos el c\u00f3digo de salida 1 (archivos cambiaron durante la lectura,
    # normal si Chunky sigue corriendo) pero fallamos si es un error real (>=2)
    tar -czf "$BACKUP_FILE.tmp" $DIRS server.properties
    TAR_EXIT=$?
    if [ "$TAR_EXIT" -ge 2 ]; then
      echo "tar fall\u00f3 con error real (c\u00f3digo $TAR_EXIT)"
      rm -f "$BACKUP_FILE.tmp"
      exit 1
    fi

    mv "$BACKUP_FILE.tmp" "$BACKUP_FILE"
    chown njcampos1 "$BACKUP_FILE"
  '';
in
{
  systemd.services.minecraft-backup = {
    description = "Backup del mundo de Minecraft";
    path = with pkgs; [
      gnutar
      gzip
      mcrcon
      coreutils
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${backupScript}";
    };
  };

  systemd.timers.minecraft-backup = {
    description = "Timer para backup de Minecraft cada 30 min";
    timerConfig = {
      OnUnitActiveSec = "30min";
      OnBootSec = "10min";
      Persistent = false;
    };
    wantedBy = [ "timers.target" ];
  };
}
