{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    
    ensureDatabases = [ "njcampos1" ];
    ensureUsers = [
      {
        name = "njcampos1";
        ensureDBOwnership = true;
      }
    ];

    initialScript = pkgs.writeText "backend-initScript" ''
      ALTER ROLE njcampos1 SUPERUSER;
    '';

    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  address         auth-method
      local all       all                     peer
      host  all       all     127.0.0.1/32    trust
      host  all       all     ::1/128         trust
    '';
  };
}