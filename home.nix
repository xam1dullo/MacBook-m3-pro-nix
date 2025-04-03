# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "admin";
  # home.homeDirectory = "/Users/admin";
   home.homeDirectory = "/Users/admin";
  home.stateVersion = "24.11";

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
    # Development
    pkgs.neovim
    pkgs.vscode
    pkgs.git
    pkgs.gh
    pkgs.nodejs_23
    pkgs.pnpm
    pkgs.rustc
    pkgs.go
    pkgs.nil
    pkgs.nixd
    
    # Terminal
    pkgs.alacritty
    pkgs.tmux
    pkgs.yazi
    pkgs.starship
    pkgs.zoxide
    pkgs.atuin
    pkgs.fzf
    pkgs.ranger
    pkgs.zsh-autosuggestions
    pkgs.xh
    pkgs.eza
    pkgs.direnv
    pkgs.deno
    
    # Productivity
    pkgs.obsidian
    pkgs.notion
    pkgs.anki
    
    # Utilities
    pkgs.bat
    pkgs.ripgrep
    pkgs.tree
    pkgs.unrar
    pkgs.unzip
    pkgs.ffmpeg
    pkgs.uv
    pkgs.gobuster
    pkgs.ngrok
    pkgs.nixpkgs-fmt
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".zshrc".source = ./home/zshrc/.zshrc;
    # ".config/wezterm".source = ~/dotfiles/wezterm;
    # ".config/skhd".source = ~/dotfiles/skhd;
    # ".config/starship".source = ./home/starship;
    # ".config/zellij".source = ~/dotfiles/zellij;
    # ".config/nvim".source = ~/dotfiles/nvim;
    # ".config/nix".source = ~/dotfiles/nix;
    # ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
    # ".config/tmux".source = ~/dotfiles/tmux;
    # ".config/ghostty".source = ./home/ghostty;
    # ".config/aerospace".source = ~/dotfiles/aerospace;
    # ".config/sketchybar".source = ~/dotfiles/sketchybar;
    # ".config/nushell".source = ~/dotfiles/nushell;
  };

  home.sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
  ];

  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
