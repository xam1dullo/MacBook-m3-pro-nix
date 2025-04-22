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
    pkgs.nixpkgs-fmt

    # Terminal
    pkgs.alacritty
    pkgs.tmux
    pkgs.yazi
    pkgs.starship
    pkgs.zoxide
    pkgs.atuin
    pkgs.fzf
    pkgs.zsh-autosuggestions
    pkgs.xh
    pkgs.eza
    pkgs.direnv
    pkgs.deno
    
    # Productivity
    pkgs.obsidian
    
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
      VISUAL = "${pkgs.neovim}/bin/nvim";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      TERM = "xterm-256color";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    
  ];

  programs.home-manager.enable = true;

programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    
    # ZSH Plugins (using the built-in plugins)
    initExtra = ''
      # Load environment
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      
      # Aliases
      alias ll="eza -la --git --icons"
      alias ls="eza --icons"
      alias cat="bat"
      alias find="fd"
      alias grep="rg"
      alias vim="nvim"
      alias e="$EDITOR"
      
      # Initialize zoxide
      eval "$(zoxide init zsh)"
      
      # Initialize starship prompt
      eval "$(starship init zsh)"
      
      # Initialize direnv
      eval "$(direnv hook zsh)"
      
      # Initialize atuin (shell history)
      eval "$(atuin init zsh)"
    '';
    
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      command_timeout = 1000;
      
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[✗](bold red)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$name]($style) ";
      };
    };
  };

   programs.tmux = {
    enable = true;
    shortcut = "a";
    terminal = "screen-256color";
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    
    extraConfig = ''
      # Additional tmux configuration
      set -g status-style "bg=#333333 fg=#5eacd3"
      set -g set-titles on
      set -g set-titles-string "#W"
      
      # Vim-like pane switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
      
      # Easier window splitting
      bind-key v split-window -h
      bind-key s split-window -v
    '';
  };

  # FZF configuration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --exclude .git";
    defaultOptions = ["--height 40%" "--layout=reverse" "--border"];
  };


 # Direnv configuration
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };


  # Bat configuration (cat replacement)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      italic-text = "always";
    };
  };
}
