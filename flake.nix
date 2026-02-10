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
    zix.url = "git+https://codeberg.org/zedddie/zix.git";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      zen-browser,
      nixdots-assets,
      zix,
      ...
    }@inputs:
    let
      specialArgs = {
        inherit (inputs) zen-browser nixdots-assets zix;
      };
    in
    {
      nixosConfigurations = {

        pc = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
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
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
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
