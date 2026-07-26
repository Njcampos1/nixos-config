{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "rails"
        "python"
        "ssh-agent"
      ];
      theme = "robbyrussell";
    };
    shellAliases = {
      z = "zeditor";
      zed = "zeditor";
      "zed." = "zeditor .";
      zp = "zeditor .";
    };
    # API key leída en runtime, no queda en el Nix store
    initContent = ''
      opencode() {
        if [ -f "$HOME/.ssh/opencode_token" ]; then
          OPENCODE_API_KEY="$(cat $HOME/.ssh/opencode_token)" command opencode "$@"
        else
          command opencode "$@"
        fi
      }
    '';
  };
}
