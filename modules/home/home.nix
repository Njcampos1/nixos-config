{
  config,
  pkgs,
  inputs,
  ...
}:

let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./ssh.nix
    ./git.nix
    ./hyprland-config.nix
    ./waybar.nix       # Barra superior personalizada
    ./alacritty.nix    # Terminal

    ./programs/zed.nix
    ./programs/vscode.nix
    ./programs/zsh.nix
    ./programs/direnv.nix
    ./programs/rider.nix
  ];

  home.username = "njcampos1";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "25.11";

  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze-dark";
  };

  home.packages =
    with pkgs;
    [
      brave
      gnumake
      gcc
      libreoffice-fresh
      cliphist
      hyprlock
      hypridle
      pavucontrol
      brightnessctl
      nwg-look
      seahorse
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      papirus-icon-theme
      evince
      yazi
    ]
    ++ [
      pkgs-unstable.claude-code
    ];
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/x-pdf" = [ "org.gnome.Evince.desktop" ];
      "application/x-bzpdf" = [ "org.gnome.Evince.desktop" ];
      "application/x-gzpdf" = [ "org.gnome.Evince.desktop" ];
    };
  };

  # ── Hypridle: Configuración de inactividad ──
  home.file.".config/hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock       # Evitar múltiples instancias de hyprlock
        before_sleep_cmd = loginctl lock-session    # Bloquear antes de suspender
        after_sleep_cmd = hyprctl dispatch dpms on  # Encender pantalla al despertar
    }

    listener {
        timeout = 300                                 # 5 min
        on-timeout = loginctl lock-session            # Bloquear pantalla
    }

    listener {
        timeout = 330                                 # 5.5 min
        on-timeout = hyprctl dispatch dpms off        # Apagar monitores
        on-resume = hyprctl dispatch dpms on          # Encender monitores al detectar actividad
    }

    listener {
        timeout = 1800                                # 30 min
        on-timeout = systemctl suspend                # Suspender computadora
    }
  '';

  # ── Dolphin: Configuración visual glassmorphism ──
  home.file.".config/dolphinrc".text = ''
    [General]
    BrowseThroughArchives=false
    ConfirmClosingMultipleTabs=true
    EditableUrl=false
    GlobalViewProps=false
    HomeUrl=file:///home/njcampos1
    RememberOpenedTabs=true
    ShowFullPath=false
    ShowFullPathInTitlebar=true
    ShowToolTips=true
    SortingChoice=0
    UseTabForSwitchingSplitView=false
    Version=202
    ViewPropsTimestamp=2024,1,1,0,0,0

    [KFileDialog Settings]
    Places Icons Auto-resize=false
    Places Icons Static Size=22

    [MainWindow]
    MenuBar=Disabled
    ToolBarsMovable=Disabled

    [PlacesPanel]
    IconSize=16

    [PreviewSettings]
    Plugins=appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,ebookthumbnail,exr,ffmpegthumbs,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail
  '';

  # ── KDE Globals: Tema Breeze Dark + acento rosa (coherente con Hyprland) ──
  home.file.".config/kdeglobals".text = ''
    [ColorEffects:Disabled]
    ChangeSelectionColor=true
    Color=56,56,56
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    Enable=false
    IntensityAmount=0
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=112,111,110
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=30,30,30
    BackgroundNormal=30,30,30
    DecorationFocus=245,194,231
    DecorationHover=245,194,231
    ForegroundActive=245,194,231
    ForegroundInactive=161,162,164
    ForegroundLink=114,162,212
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=239,240,241
    ForegroundPositive=39,174,96
    ForegroundVisited=114,162,212

    [Colors:Selection]
    BackgroundAlternate=245,194,231
    BackgroundNormal=245,194,231
    DecorationFocus=245,194,231
    DecorationHover=245,194,231
    ForegroundActive=245,194,231
    ForegroundInactive=161,162,164
    ForegroundLink=253,188,75
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=30,30,30
    ForegroundPositive=39,174,96
    ForegroundVisited=253,188,75

    [Colors:Tooltip]
    BackgroundAlternate=42,46,50
    BackgroundNormal=42,46,50
    DecorationFocus=245,194,231
    DecorationHover=245,194,231
    ForegroundActive=245,194,231
    ForegroundInactive=161,162,164
    ForegroundLink=114,162,212
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=239,240,241
    ForegroundPositive=39,174,96
    ForegroundVisited=114,162,212

    [Colors:View]
    BackgroundAlternate=27,27,27
    BackgroundNormal=20,20,20
    DecorationFocus=245,194,231
    DecorationHover=245,194,231
    ForegroundActive=245,194,231
    ForegroundInactive=161,162,164
    ForegroundLink=114,162,212
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=239,240,241
    ForegroundPositive=39,174,96
    ForegroundVisited=114,162,212

    [Colors:Window]
    BackgroundAlternate=30,30,30
    BackgroundNormal=24,24,24
    DecorationFocus=245,194,231
    DecorationHover=245,194,231
    ForegroundActive=245,194,231
    ForegroundInactive=161,162,164
    ForegroundLink=114,162,212
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=239,240,241
    ForegroundPositive=39,174,96
    ForegroundVisited=114,162,212

    [General]
    ColorScheme=BreezeDark
    Name=Breeze Dark
    shadeSortColumn=true

    [Icons]
    Theme=Papirus-Dark

    [KDE]
    AccentColor=245,194,231
    LookAndFeelPackage=org.kde.breezedark.desktop
    SingleClick=false
    widgetStyle=breeze

    [WM]
    activeBackground=24,24,24
    activeForeground=239,240,241
    inactiveBackground=20,20,20
    inactiveForeground=161,162,164
  '';

  home.file.".config/rofi" = {
    source = ../rofi; # Asumiendo que pegaste la carpeta al lado de home.nix
    recursive = true;
  };
}
