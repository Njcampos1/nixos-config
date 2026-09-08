{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    jetbrains.rider
    dotnet-sdk_8
  ];

  # El .desktop de Rider en nixpkgs no declara MimeType, así que nunca
  # aparece como candidato para abrir nada. Lo sobreescribimos: home-manager
  # lo coloca en ~/.local/share/applications, que XDG resuelve con más
  # prioridad que /run/current-system/sw/share/applications.
  xdg.desktopEntries.rider = {
    name = "Rider";
    genericName = ".NET IDE from JetBrains";
    exec = "rider %f";
    icon = "rider";
    terminal = false;
    type = "Application";
    categories = [ "Development" ];
    mimeType = [
      "application/x-ms-solution"
      "text/x-csharp"
      "text/x-csproj"
    ];
  };

  # .sln no tiene mimetype propio en shared-mime-info (se detecta como
  # text/plain genérico). Registramos uno dedicado basado en la extensión.
  xdg.dataFile."mime/packages/x-ms-solution.xml".source =
    pkgs.writeText "x-ms-solution.xml" ''
      <?xml version="1.0" encoding="UTF-8"?>
      <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        <mime-type type="application/x-ms-solution">
          <comment>Visual Studio Solution</comment>
          <glob pattern="*.sln"/>
        </mime-type>
      </mime-info>
    '';

  xdg.mimeApps.defaultApplications = {
    "application/x-ms-solution" = [ "rider.desktop" ];
    "text/x-csharp" = [ "rider.desktop" ];
    "text/x-csproj" = [ "rider.desktop" ];
  };

  # Por si el módulo xdg.dataFile no dispara el refresco por sí solo,
  # forzamos regenerar las bases de datos MIME/desktop tras cada switch.
  home.activation.refreshMimeCaches = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.shared-mime-info}/bin/update-mime-database $VERBOSE_ARG "$HOME/.local/share/mime"
    $DRY_RUN_CMD ${pkgs.desktop-file-utils}/bin/update-desktop-database $VERBOSE_ARG "$HOME/.local/share/applications"
  '';
}
