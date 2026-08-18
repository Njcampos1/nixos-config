# modules/apps/dotnet.nix
#
# Entorno de desarrollo C# / .NET + JetBrains Rider.
#
# Decisión de diseño: el SDK va a nivel de SISTEMA, no solo en un devShell.
# Motivo: Rider se lanza desde el menú de aplicaciones, no desde una terminal,
# así que NO hereda el entorno de `nix develop` ni de direnv. Si el SDK solo
# existiera dentro del flake del proyecto, Rider no lo encontraría nunca.
# (Ver JetBrains YouTrack RIDER-85715.)
#
# Los flakes por proyecto siguen siendo útiles: fijan la versión exacta del SDK
# para el trabajo en terminal y para que el proyecto sea reproducible en otra máquina.

{ pkgs, ... }:

let
  # SDK combinado. Tener 8 y 9 a la vez evita tener que reconstruir el sistema
  # cuando un proyecto del curso pida <TargetFramework>net8.0</TargetFramework>
  # y otro pida net9.0.
  #
  # ¿Necesitas .NET 10? Verifica primero que exista en tu canal:
  #     nix search nixpkgs dotnetCorePackages.sdk_10_0
  # y si está, agrégalo a esta lista.
  dotnet = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      sdk_9_0
    ];
in
{
  environment.systemPackages = with pkgs; [
    dotnet

    # El IDE del curso.
    jetbrains.rider

    # Depurador de .NET independiente del IDE. Rider trae el suyo propio, pero
    # este te sirve para depurar desde VS Code / Zed, que ya tienes instalados.
    netcoredbg

    # Utilidades que aparecen constantemente en cursos de C#:
    # - powershell: algunos materiales de Microsoft dan los comandos en pwsh
    # - mono: solo si el curso toca .NET Framework antiguo o Unity
    # powershell
    # mono
  ];

  environment.variables = {
    # Rider y el CLI buscan el SDK aquí. Sin esto, Rider puede arrancar
    # diciendo "No .NET SDK found" aunque `dotnet --version` funcione.
    DOTNET_ROOT = "${dotnet}/share/dotnet";

    # Sin telemetría y sin el mensaje de bienvenida en cada comando.
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_NOLOGO = "1";
  };

  # Rider (como todo IDE de JetBrains) vigila el árbol de archivos completo del
  # proyecto. Con el límite por defecto de inotify verás el aviso
  # "external file changes sync may be slow" y la indexación se degrada.
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 512;
  };

  # Tu configuration.nix ya activa programs.nix-ld con icu, openssl, zlib y curl,
  # que es justo lo que necesitan los binarios precompilados que Rider descarga
  # (ReSharper backend, plugins). No hace falta tocar nada ahí.
}
