{
  description = "nason flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, home-manager, stylix }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in {
      overlays.default = final: prev: {
        neovimConfigured = final.callPackage ./packages/neovimConfigured { };
      };

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };
        in {
          inherit (pkgs) neovimConfigured;
        });

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in {
          default = pkgs.mkShell {
            inputsFrom = with pkgs; [ ];
            buildInputs = with pkgs; [ nixpkgs-fmt ];
          };
        });

      homeConfigurations = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in {
          nason = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./users/nason/home.nix ];
          };
        });

      nixosConfigurations = let
        aarch64Base = {
          system = "aarch64-linux";
          modules = with self.nixosModules; [
            ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
            home-manager.nixosModules.home-manager
            traits.overlay
            traits.base
            services.openssh
          ];
        };
        x86_64Base = {
          system = "x86_64-linux";
          modules = with self.nixosModules; [
            ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
            home-manager.nixosModules.home-manager
            traits.overlay
            traits.base
            services.openssh
          ];
        };
      in with self.nixosModules; {
        # you will need a new workstation here if you want to build this
        # couldn't make the LUKS stuff system independent
        druid = nixpkgs.lib.nixosSystem {
          inherit (x86_64Base) system;
          modules = x86_64Base.modules ++ [
            platforms.druid
            traits.workstation
            stylix.nixosModules.stylix
            users.nason
          ];
        };
        docker = nixpkgs.lib.nixosSystem {
          inherit (aarch64Base) system;
          modules = aarch64Base.modules ++ [
            platforms.container
            traits.base
            stylix.nixosModules.stylix
            users.nason
          ];
        };
      };

      nixosModules = {
        platforms.container = ./platforms/container.nix;
        platforms.druid = ./platforms/druid.nix;
        traits.overlay = { nixpkgs.overlays = [ self.overlays.default ]; };
        traits.base = ./traits/base.nix;
        services.openssh = ./services/openssh.nix;
        traits.workstation = ./traits/workstation.nix;
        users.nason = ./users/nason/system.nix;
      };

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in {
          format = pkgs.runCommand "check-format" {
            buildInputs = with pkgs; [ rustfmt cargo ];
          } ''
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
            touch $out # it worked!
          '';
        });

    };
}

