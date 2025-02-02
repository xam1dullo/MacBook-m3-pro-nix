{
  description = "Khamidullo nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
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
        [ 
					

        ];

	homebrew = {
		enable = true;
		casks = [
			# "hammerspoon"
			"zen-browser"
			"raycast"
			# "the-unarchiver"
		];
		onActivation.cleanup = "zap";
	} ;

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
				dock.autohide = true;
				dock.persistent-apps = [
					"${pkgs.alacritty}/Applications/Alacritty.app"
					"/Applications/Zen Browser.app"
					"${pkgs.obsidian}/Applications/Obsidian.app"
					"${pkgs.vscode}/Applications/Visual Studio Code.app"
					"/System/Applications/Mail.app"
					"/System/Applications/Calendar.app"
				] ;
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
      
      security. pam. enableSudoTouchIdAuth = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
      	configuration
				nix-homebrew.darwinModules.nix-homebrew
				home-manager.darwinModules.home-manager
				{
					nix-homebrew = {
						enable = true;
						# Apple Silicon Only
						enableRosetta = true;
						# User owning the Homebrew prefix
						user = "admin";
						autoMigrate = true;
					};
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.admin = import ./home.nix;
					};
				}
			];
			};

     darwinPackages = self.darwinConfigurations."pro".pkgs;
  };
}
