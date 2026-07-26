{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    spotify
    teams-for-linux
  ];
}