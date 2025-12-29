{
  description = "my huome manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixdots-assets = {
      url = "git+https://codeberg.org/zedddie/nixdots-assets.git";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      zen-browser,
      nixdots-assets,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      specialArgs = {
        inherit (inputs) zen-browser nixdots-assets;
      };
    in
    {
      nixosConfigurations = {

        pc = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/pc/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.zedddie = import ./hosts/pc/home.nix;
            }
          ];
        };

        lap = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/laptop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.zedddie = import ./hosts/laptop/home.nix;
            }
          ];
        };
      };
    };
}
