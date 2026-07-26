{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  keymap = import ../lib/keymap.nix;

  zedSettings = {
    theme = "One Dark";
    ui_font_size = 16;
    buffer_font_size = 14;
    buffer_font_family = "Fira Code";
    autosave = "on_focus_change";

    terminal = {
      alternate_scroll = "off";
      font_family = "Fira Code";
    };

    features = {
      copilot = true;
      edit_prediction_provider = "copilot";
    };

    inline_completions = {
      provider = "copilot";
    };

    agent = {
      default_model = {
        enable_thinking = true;
        provider = "copilot_chat";
        model = "claude-haiku-4.5";
      };
    };

    assistant = {
      version = "2";
      default_model = {
        provider = "opencode";
        model = "DeepSeek V4 Flash";
      };
    };

    # Ocultamos los modelos Zen/Free y forzamos los Go
    language_models = {
      opencode = {
        show_zen_models = false;
        show_go_models = true;
        show_free_models = false;
      };
    };

    languages = {
      Python = {
        tab_size = 4;
        preferred_line_length = 88;
        format_on_save = "on";
      };
      Ruby = {
        tab_size = 2;
        format_on_save = "on";
      };
      Nix = {
        tab_size = 2;
        formatter = {
          language_server = {
            name = "nixd";
          };
        };
        format_on_save = "on";
      };
      "LaTeX" = {
        tab_size = 2;
        soft_wrap = "editor_width";
        format_on_save = "off";
      };
    };

    lsp = {
      nixd = {
        settings = {
          formatting = {
            command = [ "nixfmt" ];
          };
        };
      };
      texlab = {
        settings = {
          texlab = {
            build = {
              executable = "latexmk";
              args = [
                "-pdf"
                "-interaction=nonstopmode"
                "-synctex=1"
                "%f"
              ];
              onSave = true;
            };
          };
        };
      };
    };
  };

  # Creamos el JSON de manera estática y pura en el Nix Store
  settingsJson = pkgs.writeText "zed-settings.json" (builtins.toJSON zedSettings);

in
{
  home.packages = with pkgs; [
    nil
    nixd
    nixfmt-rfc-style
    texlab
    opencode
  ];

  programs.zed-editor = {
    enable = true;

    # Envolvemos el binario original para inyectar la API key antes de que inicie la app
    package = pkgs.symlinkJoin {
      name = "zed-wrapped";
      paths = [ pkgs-unstable.zed-editor ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        # Envolvemos solo zeditor, que es el ejecutable real
        wrapProgram $out/bin/zeditor \
          --run 'export OPENCODE_API_KEY=$(cat ${config.home.homeDirectory}/.ssh/opencode_token 2>/dev/null || echo "")'

        # Modificamos el archivo .desktop para que Rofi ejecute nuestro binario con la API key
        rm -rf $out/share/applications
        mkdir -p $out/share/applications
        cp ${pkgs-unstable.zed-editor}/share/applications/*.desktop $out/share/applications/
        sed -i "s|Exec=zeditor|Exec=$out/bin/zeditor|g" $out/share/applications/*.desktop
      '';
    };

    extensions = [
      "ruby"
      "python"
      "nix"
      "opencode"
      "latex"
    ];

    userSettings = { };

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "${keymap.newThing}" = "workspace::NewFile";
          "${keymap.closeThing}" = "pane::CloseActiveItem";
          "${keymap.commandPalette}" = "command_palette::Toggle";
          "${keymap.quickOpen}" = "file_finder::Toggle";
          "${keymap.findInAll}" = "pane::DeploySearch";
          "${keymap.nextThing}" = "pane::ActivateNextItem";
          "${keymap.prevThing}" = "pane::ActivatePrevItem";
          "${keymap.splitRight}" = "pane::SplitRight";
          "${keymap.splitDown}" = "pane::SplitDown";
          "${keymap.reopenClosed}" = "pane::ReopenClosedItem";
        };
      }
    ];
  };

  # Copiamos el JSON usando rutas estáticas absolutas de NixOS, inmunes a problemas de sudo
  home.activation = {
    setupZedSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${config.home.homeDirectory}/.config/zed"
      cp -f "${settingsJson}" "${config.home.homeDirectory}/.config/zed/settings.json"
      chmod 644 "${config.home.homeDirectory}/.config/zed/settings.json"
    '';
  };
}
