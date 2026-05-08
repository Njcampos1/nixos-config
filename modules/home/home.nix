{ config, pkgs, ... }:

{
  imports = [
    ./ssh.nix 
    ./git.nix
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
 
  programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-vscode-remote.remote-ssh
        yzhang.markdown-all-in-one
        ms-azuretools.vscode-docker
        github.copilot
        github.copilot-chat
      ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "rails" "python" "ssh-agent" ];
      theme = "robbyrussell";
    }; 
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; 
  };

  home.packages = with pkgs; [
    gnumake
    gcc
    libreoffice-fresh
  ];
}