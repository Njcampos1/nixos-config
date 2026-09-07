# modules/home/waybar.nix
{ pkgs, ... }:

{
  # ─────────────────────────────────────────────────────────────────────────────
  # FUENTES: Nerd Font para íconos en la barra
  # ─────────────────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # ─────────────────────────────────────────────────────────────────────────────
  # WAYBAR: Gestionado completamente por Home Manager
  # ─────────────────────────────────────────────────────────────────────────────
  programs.waybar = {
    enable = true;
    systemd.enable = true; # Arranca como servicio de usuario systemd

    settings = [
      # ────────────────────────────────
      # Monitor principal: DP-1 (1440p)
      # ────────────────────────────────
      {
        name = "main";
        layer = "top";
        position = "top";
        output = [ "DP-1" ];
        height = 34;
        spacing = 0;
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;

        modules-left = [ "clock" "mpris" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "network" "pulseaudio" "tray" ];

        # ── Workspaces estilo letras ──
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "A";
            "2" = "B";
            "3" = "C";
            "4" = "D";
            "5" = "E";
          };
          persistent-workspaces = {
            "DP-1" = [ 1 2 3 4 5 ];
          };
          on-click = "activate";
          sort-by-number = true;
          active-only = false;
        };

        "clock" = {
          format = "  {:%H:%M}";
          format-alt = "  {:%A, %d %b %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "mpris" = {
          format = "  {artist} - {title}";
          format-paused = "  {artist} - {title}";
          format-stopped = "";
          player-icons = {
            default = "▶";
            spotify = "";
            firefox = "󰈹";
          };
          status-icons = {
            paused = "⏸";
          };
          max-length = 45;
          ellipsis = "…";
          interval = 1;
        };

        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈀  {ipaddr}/{cidr}";
          format-disconnected = "󰌙  Sin conexión";
          tooltip-format-wifi = "{essid} ({signalStrength}%)  {ipaddr}";
          tooltip-format-ethernet = "{ifname}  {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          format = "{icon}  {volume}%";
          format-muted = "󰝟  Silencio";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
            headphone = "󰋋";
            headset = "󰋎";
          };
          on-click = "pavucontrol";
          scroll-step = 5;
        };

        "tray" = {
          icon-size = 16;
          spacing = 8;
        };
      }

      # ─────────────────────────────────────────
      # Monitor secundario: HDMI-A-1 (1080p)
      # ─────────────────────────────────────────
      {
        name = "secondary";
        layer = "top";
        position = "top";
        output = [ "HDMI-A-1" ];
        height = 34;
        spacing = 0;
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;

        modules-left = [ "clock" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "network" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "6" = "A";
            "7" = "B";
            "8" = "C";
            "9" = "D";
            "10" = "E";
          };
          persistent-workspaces = {
            "HDMI-A-1" = [ 6 7 8 9 10 ];
          };
          on-click = "activate";
          sort-by-number = true;
          active-only = false;
        };

        "clock" = {
          format = "  {:%H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "network" = {
          format-ethernet = "󰈀  {ipaddr}/{cidr}";
          format-wifi = "  {essid}";
          format-disconnected = "󰌙";
          tooltip-format-ethernet = "{ifname}  {ipaddr}/{cidr}";
        };
      }
    ];

    style = ''
      /* ════════════════════════════════════════════════════════════
         Waybar — Estilo inspirado en dots-hyprland / Catppuccin Mocha
         ════════════════════════════════════════════════════════════ */

      * {
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font Mono", monospace;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
        box-shadow: none;
        transition: all 0.2s ease;
      }

      window#waybar {
        background: rgba(20, 20, 30, 0.82);
        color: #cdd6f4;
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.055);
      }

      #clock,
      #mpris,
      #network,
      #pulseaudio,
      #tray {
        padding: 2px 14px;
        color: #cdd6f4;
      }

      #clock {
        color: #89dceb;
        font-weight: 600;
        letter-spacing: 0.3px;
      }

      #mpris {
        color: #a6e3a1;
        padding-left: 4px;
      }

      #mpris.paused {
        color: #6c7086;
      }

      #mpris.stopped {
        opacity: 0;
        min-width: 0;
        padding: 0;
        margin: 0;
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        color: #45475a;
        background: transparent;
        border-radius: 6px;
        padding: 2px 8px;
        min-width: 24px;
        font-weight: 700;
        font-size: 12px;
        letter-spacing: 0.5px;
      }

      #workspaces button:hover {
        color: #cdd6f4;
        background: rgba(137, 180, 250, 0.10);
        border-radius: 6px;
      }

      #workspaces button.active {
        color: #cdd6f4;
        background: rgba(137, 180, 250, 0.20);
        border-radius: 8px;
        padding: 2px 11px;
      }

      #workspaces button.urgent {
        color: #f38ba8;
        background: rgba(243, 139, 168, 0.16);
        border-radius: 6px;
        animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
        to { opacity: 0.5; }
      }

      #network {
        color: #89b4fa;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #pulseaudio {
        color: #cba6f7;
      }

      #pulseaudio.muted {
        color: #45475a;
      }

      #tray {
        padding-right: 10px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: rgba(243, 139, 168, 0.18);
        border-radius: 4px;
      }
    '';
  };
}
