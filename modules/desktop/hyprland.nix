{ pkgs, ... }:

{
  # Habilita Hyprland a nivel de sistema para configurar cachés de binarios y wrappers de seguridad
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # Soporte para apps que no corren nativas en Wayland
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  # ────────────────────────────

  # Variables de entorno esenciales para Wayland y tu GPU AMD
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # Evita cursores invisibles en algunas configuraciones
    NIXOS_OZONE_WL = "1"; # Indica a las apps de Electron (VSCode, Discord) que usen Wayland

    # Permite que portales e interfaces Qt encuentren apps instaladas vía Home Manager
    XDG_DATA_DIRS = [
      "$HOME/.nix-profile/share"
      "/etc/profiles/per-user/$USER/share"
    ];
  };

  # Portales para integración de escritorio
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        # Usamos GTK para los diálogos de apertura y selección de archivos
        "org.freedesktop.impl.portal.FileDialog" = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        default = [ "hyprland" ];
      };
    };
  };
}
