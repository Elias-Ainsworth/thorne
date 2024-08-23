{
  description = "...there was giuen to me a thorne in the flesh...lest I should be exalted aboue measure. - 2 Corinthians 12:7 AV1611";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nix-colors.url = "github:misterio77/nix-colors";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    devenv.url = "github:cachix/devenv";
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lobster.url = "github:justchokingaround/lobster";
    my-assets = {
      url = "github:Elias-Ainsworth/assets";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    pcName = "thornbush";
    myUserName = "elias-ainsworth";
    myName = "Elias Ainsworth";
    mailId = "pilum-murialis.toge@proton.me";

    nurNoPkgs = import inputs.nur {
      nurpkgs = import nixpkgs {inherit system;};
    };

    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    caches = {
      nix.settings = {
        builders-use-substitutes = true;
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://cache.garnix.io"
          # "https://hyprland.cachix.org"
          "https://nix-gaming.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];
      };
    };
    overlays = {
      nixpkgs.overlays = with inputs; [
        my-assets.overlays.default
        # hyprland.overlays.default
        (import ./pkgs)
      ];
    };
  in {
    devShell.${system} = pkgs.mkShell {
      packages = with pkgs; [lolcat alejandra nil];
      shellHook = ''
        printf "\e[3m\e[1m%s\em\n" "茨やアザミ、荊や樹皮、暗闇から私たちを守ってくれるこれらのものに感謝しなさい。" | lolcat
      '';
    };
    nixosConfigurations.${pcName} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs nurNoPkgs;
        inherit pcName myUserName myName mailId;
      };
      modules = with inputs; [
        caches
        overlays
        stylix.nixosModules.stylix
        nur.nixosModules.nur
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
        (import ./nixos/config.nix)
      ];
    };
  };
}
