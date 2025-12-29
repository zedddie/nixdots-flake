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
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations = {
        pc = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit zen-browser;
            inherit nixdots-assets;
          };
          modules = [ ./hosts/pc/home.nix ];
        };
        lap = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit zen-browser;
            inherit nixdots-assets;
          };
          modules = [ ./hosts/laptop/home.nix ];
        };
      };
    };
}
