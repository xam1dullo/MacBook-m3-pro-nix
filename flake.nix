{
  description = "Khamidullo nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

		# Nix darwin
	  nix-darwin = {
			url = "github:LnL7/nix-darwin/master";
    	inputs.nixpkgs.follows = "nixpkgs";
		};
	  nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

		 # Home Manager
    home-manager = {
			url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager}:
  let
    configuration = { pkgs, config,  ... }: {

			nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        with pkgs; [
					neovim
					alacritty
					obsidian
					mkalias
					vscode
					tmux
					git
					gh
					zoxide
					nodejs_23
					pnpm
					direnv
					ffmpeg
          uv
					rustc
					go
					gobuster
					ngrok
          bat

					ripgrep
					tree
					unrar
					unzip

					nixpkgs-fmt
					nil
  				nixd

					obsidian
					# sublime4
        ];


    homebrew = {
        enable = true;
        brews = [
          "mas"
        ];
        casks = [
            "firefox"
            "iina"
           	"hammerspoon"
    				"zen-browser"
    				"raycast"
    				"the-unarchiver"
    				"obs"
    				"vlc"
            "flameshot"
            "termius"
    				"zed"
    				"notion"
    				"anki"
        ];
        masApps = {
        };
        onActivation.cleanup = "zap";
    };


      fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
      ];

		system.activationScripts.applications.text = let
			env = pkgs.buildEnv {
				name = "system-applications";
				paths = config.environment.systemPackages;
				pathsToLink = "/Applications";
			};
		in
			pkgs.lib.mkForce ''
			# Set up applications.
			echo "setting up /Applications..." >&2
			rm -rf /Applications/Nix\ Apps
			mkdir -p /Applications/Nix\ Apps
			find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
			while read -r src; do
				app_name=$(basename "$src")
				echo "copying $src" >&2
				${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
			done
				'';

      system.defaults = {
				# dock.autohide = true;
				 dock = {
					autohide = true;
					orientation = "right";
					show-process-indicators = false;
					show-recents = false;
					static-only = true;
				  persistent-apps = [
						"${pkgs.alacritty}/Applications/Alacritty.app"
						"/Applications/Zen Browser.app"
						"${pkgs.obsidian}/Applications/Obsidian.app"
						"${pkgs.vscode}/Applications/Visual Studio Code.app"
						"/System/Applications/Mail.app"
						"/System/Applications/Calendar.app"
				] ;
				};
				finder = {
					AppleShowAllExtensions = true;
					ShowPathbar = true;
					FXEnableExtensionChangeWarning = false;
				};
				finder.FXPreferredViewStyle = "clmv" ;
				screencapture.location = "/Users/admin/Pictures/Screenshots";
		};

      # Necessary for using flakes on this system.

      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

			security.pam.enableSudoTouchIdAuth = true;
		  users.users.admin.home = "/Users/admin";
			home-manager.backupFileExtension = "backup";
			nix.configureBuildUsers = true;
		  };


  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."pro" = nix-darwin.lib.darwinSystem {
      modules = [
      	configuration
				nix-homebrew.darwinModules.nix-homebrew
				home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.admin = import ./home.nix;
        }
			];
			};

     darwinPackages = self.darwinConfigurations."pro".pkgs;
  };
}
