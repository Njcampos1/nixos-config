# modules/home/hyprland-config.nix
{ pkgs, ... }:

{
  # ─────────────────────────────────────────────────────────────────────────────
  # PAQUETES: Herramientas del sistema y soporte visual
  # ─────────────────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    waybar
    swww
    rofi
    kitty
    dunst
    libnotify
    grim
    slurp
    wl-clipboard
    xfce.thunar
    swayosd # OSD visual para volumen y brillo
    brightnessctl # Control de brillo por consola
    pavucontrol # Mezclador de audio visual
    cliphist # Historial de portapapeles
    hyprlock # Bloqueo de pantalla
    hypridle # Demonio de inactividad
    playerctl # Control de medios multimedia
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      # ── Monitores (Hardware) ──
      # Izquierda: HP 1080p @ 144Hz
      # Derecha / Principal: Samsung G6 1440p @ 240Hz
      monitor = [
        "HDMI-A-1, 1920x1080@144, -1920x0, 1"
        "DP-1, 2560x1440@240, 0x0, 1"
      ];

      # ── Entrada y Entorno ──
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        accel_profile = "flat";
      };

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "NIXOS_OZONE_WL,1"
        # Fuerza a las apps a mirar en el store de usuario y de sistema
        "XDG_DATA_DIRS,$HOME/.nix-profile/share:/etc/profiles/per-user/$USER/share:/run/current-system/sw/share:/usr/share"
      ];

      # ── Apariencia Visual (Estilo Hyprdots) ──
      general = {
        gaps_in = 3;
        gaps_out = 6;
        border_size = 2;
        "col.active_border" = "rgb(f5c2e7) rgb(000000) 45deg";
        "col.inactive_border" = "rgb(24273A)";
        layout = "dwindle";
        resize_on_border = true;
        extend_border_grab_area = 30;
        hover_icon_on_border = true;
      };

      decoration = {
        rounding = 0;
        dim_special = 0.2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        blur = {
          enabled = true;
          size = 5;
          popups = true;
          passes = 4;
          new_optimizations = true;
          vibrancy = 0.4;
          ignore_opacity = true;
          special = true;
        };

        shadow = {
          enabled = false;
        };
      };

      # ── Animaciones (Estilo Hyprdots) ──
      animations = {
        enabled = true;
        bezier = [
          "easeOutBack, 0.34, 1.56, 0.64, 1"
          "sideDown, 0.3, 1, 0.7, 1"
          "ease, 0.25, 0.1, 0.25, 1.0"
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear, 0, 0, 1, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1.0"
          "quick, 0.15, 0, 0.1, 1"
        ];
        animation = [
          "windowsIn, 1, 2.5, easeOutQuint, slide"
          "windowsOut, 1, 2.5, sideDown, slide"
          "windows, 1, 5.0, easeOutQuint"
          "fadeIn, 1, 2.0, almostLinear"
          "fadeOut, 1, 1.8, almostLinear"
          "fade, 1, 2.8, quick"
          "layers, 1, 4, ease, slide"
          "layersOut, 1, 4, ease, fade"
          "workspaces, 1, 2.0, easeInOutCubic, slide"
          "workspacesIn, 1, 3.0, easeInOutCubic, slide"
          "workspacesOut, 1, 3.0, easeInOutCubic, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # ── Reglas de Ventana ──
      windowrulev2 = [
        "float, class:^(thunar)$"
        "size 900 600, class:^(thunar)$"
        "center, class:^(thunar)$"
        "opacity 0.95 0.90, class:^(kitty)$"
      ];

      # ── Configuración Completa de Atajos de Teclado ──
      bind = [
        # 🚀 Aplicaciones y Sistema
        "$mod, Q, exec, kitty"
        "$mod, R, exec, ~/.config/rofi/launcher/launcher.sh"
        "$mod, E, exec, thunar"
        "$mod, B, exec, cliphist list | rofi -dmenu -p 'Portapapeles' | cliphist decode | wl-copy"
        "$mod SHIFT, L, exec, hyprlock"
        "$mod, W, exec, pkill -SIGUSR1 waybar"

        # 📸 Capturas de Pantalla
        ", Print, exec, grim ~/Pictures/$(date +%Y%m%d_%H%M%S).png"
        "$mod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"

        # 🪟 Gestión de Ventanas
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, V, togglefloating,"
        "$mod, F, fullscreen, 0"

        # 🔀 Foco en Tiling (Mirar a...)
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # 🔀 Movimiento en Tiling (Desplazar ventana con Shift)
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # 🗂️ Workspaces: Cambiar al Escritorio 1-10
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # 🗂️ Workspaces: Mover ventana activa al Escritorio 1-10
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # 🎵 Control de Audio y Brillo (Integración SwayOSD)
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

        # ➕ Controles Multimedia Adicionales (Heredados de Hyprdots)
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];

      # Interacción del ratón (Mover/Redimensionar)
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };

    extraConfig = ''
      # ── Inicialización de Entorno y Llavero ──
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_DATA_DIRS
      exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_DATA_DIRS
      exec-once = gnome-keyring-daemon --start --components=secrets

      # Refrescar la base de datos de aplicaciones asociadas por el usuario
      exec-once = update-desktop-database -v ~/.local/share/applications

      # Esta línea arranca la ventana invisible que te pedirá contraseñas si el sistema lo requiere
      exec-once = ${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1

      # ── Autostart de Servicios ──
      exec-once = waybar
      exec-once = sleep 1 && pkill -SIGUSR1 waybar
      exec-once = swww-daemon
      exec-once = swww img ~/Pictures/windows.jpg --transition-type wipe --transition-fps 144
      exec-once = swayosd-server
      exec-once = hypridle
      exec-once = wl-paste --type text --watch cliphist store
      exec-once = wl-paste --type image --watch cliphist store

      # ── Efectos de Capas (Blur en barra y buscador) ──
      layerrule = blur, waybar
      layerrule = ignorezero, waybar
      layerrule = blur, rofi
      layerrule = ignorezero, rofi

      # ── Mapeo de Workspaces por Monitor ──
      workspace = 1, monitor:DP-1, default:true
      workspace = 2, monitor:DP-1
      workspace = 3, monitor:DP-1
      workspace = 4, monitor:DP-1
      workspace = 5, monitor:DP-1

      workspace = 6, monitor:HDMI-A-1, default:true
      workspace = 7, monitor:HDMI-A-1
      workspace = 8, monitor:HDMI-A-1
      workspace = 9, monitor:HDMI-A-1
      workspace = 10, monitor:HDMI-A-1
    '';
  };
}
