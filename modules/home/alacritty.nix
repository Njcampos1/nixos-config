# modules/home/alacritty.nix
{ ... }:

{
  # ─────────────────────────────────────────────────────────────────────────────
  # ALACRITTY: Glassmorphism + Catppuccin Mocha + acento rosa
  # Coherente con la paleta de waybar.nix y modules/rofi/launcher/style.rasi
  # ─────────────────────────────────────────────────────────────────────────────
  programs.alacritty = {
    enable = true;

    settings = {
      general.live_config_reload = true;

      window = {
        opacity = 0.85;
        blur = true;
        decorations = "none";
        dynamic_padding = true;
        padding = {
          x = 14;
          y = 12;
        };
        dimensions = {
          columns = 110;
          lines = 30;
        };
      };

      font = {
        size = 11.0;
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Italic";
        };
      };

      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
        blink_interval = 600;
      };

      colors = {
        primary = {
          background = "#0a0a12";
          foreground = "#eff0f1";
        };

        cursor = {
          text = "#1a1a2e";
          cursor = "#f5c2e7";
        };

        selection = {
          text = "#eff0f1";
          background = "#45475a";
        };

        normal = {
          black = "#1a1a2e";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#89dceb";
          white = "#a1a2a4";
        };

        bright = {
          black = "#585b70";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#cba6f7";
          cyan = "#89dceb";
          white = "#eff0f1";
        };

        hints = [
          {
            start = {
              foreground = "#1a1a2e";
              background = "#f5c2e7";
            };
            end = {
              foreground = "#1a1a2e";
              background = "#f5c2e7";
            };
          }
        ];

        search = {
          matches = {
            foreground = "#1a1a2e";
            background = "#f5c2e7";
          };
          focused_match = {
            foreground = "#1a1a2e";
            background = "#a6e3a1";
          };
        };
      };
    };
  };
}
