{
  description = "My NixOS configuration flake";

  inputs = {
    # NixOS official package source, here using the nixos-23.11 branch
    nixpkgs.url =
      "github:NixOS/nixpkgs/nixos-24.05"; # "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, ... }:
    let
      system = "x86_64-linux"; # change this if other architecture
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;


    in {
      nixosConfigurations = {
        laptop = lib.nixosSystem {
          inherit system;
          modules = [
            laptops/os/configuration.nix
						modules/networking.nix
						modules/locale.nix
						modules/grafana.nix
						modules/kubernetes.nix
          ];
        };
      };
      hmConfig = {
        laptop = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            catppuccin.homeManagerModules.catppuccin
            laptops/homemanager/home.nix
          ];
        };
      };
    };
}
