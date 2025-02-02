{ pkgs, ... }: {
  home.username = "admin";
  home.homeDirectory = "/Users/admin";

  home.packages = [
    pkgs.neovim
    pkgs.alacritty
    pkgs.obsidian
    pkgs.mkalias
    pkgs.vscode
    pkgs.tmux
    pkgs.git
    pkgs.gh
    pkgs.zoxide
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}