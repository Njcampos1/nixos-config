{ pkgs, inputs, ... }:

let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions =
      with pkgs.vscode-extensions;
      [
        ms-vscode-remote.remote-ssh
        yzhang.markdown-all-in-one
        ms-azuretools.vscode-docker
        github.copilot
        github.copilot-chat
      ]
      ++ [
        # Extensión de Claude Code desde la rama inestable
        pkgs-unstable.vscode-extensions.anthropic.claude-code
      ];
  };

  # Instalamos Cursor (usamos unstable porque se actualiza muy rápido)
  home.packages = [
    pkgs-unstable.code-cursor
  ];
}
