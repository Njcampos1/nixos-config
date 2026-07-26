# modules/services/minecraft-server.nix
{ pkgs, ... }:

let
  serverDir = "/var/lib/minecraft-server";
in
{
  users.users.minecraft = {
    isSystemUser = true;
    group = "minecraft";
    home = serverDir;
    createHome = true;
  };
  users.groups.minecraft = { };

  systemd.services.minecraft-server = {
    description = "Servidor Paper de Minecraft (hardcore)";
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "minecraft";
      Group = "minecraft";
      WorkingDirectory = serverDir;
      ExecStart = ''
        ${pkgs.temurin-bin-25}/bin/java \
          -Xms4G -Xmx4G \
          -XX:+UseG1GC -XX:+ParallelRefProcEnabled \
          -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions \
          -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 \
          -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
          -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 \
          -jar ${serverDir}/paper.jar nogui
      '';
      Restart = "on-failure";
      RestartSec = 10;
    };
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
}
