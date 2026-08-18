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

    ./programs/zed.nix
    ./programs/vscode.nix
    ./programs/zsh.nix
    ./programs/direnv.nix
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
      alacritty
      seahorse
      xfce.thunar
      evince
      yazi
    ]
    ++ [
      pkgs-unstable.claude-code
    ];
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/x-pdf" = [ "org.gnome.Evince.desktop" ];
      "application/x-bzpdf" = [ "org.gnome.Evince.desktop" ];
      "application/x-gzpdf" = [ "org.gnome.Evince.desktop" ];
    };
  };
  home.file.".config/rofi" = {
    source = ../rofi; # Asumiendo que pegaste la carpeta al lado de home.nix
    recursive = true;
  };
}
