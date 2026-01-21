{ pkgs, ... }: {
  imports = [ ../../base/common-home.nix ];
  programs.git.signing = {
    key = "4DF5F89B318FD73C051403AABCA49F4B8DAAE8ED";
    signByDefault = true;
  };
  programs.fish.shellAbbrs = {
    snrs = "sudo nixos-rebuild switch --flake ~/.config/nix/#lap --impure";
    # snrs = "sudo nixos-rebuild switch --flake ~/.config/nix/#$(whoami) --impure"; mb later
  };
  home.packages = with pkgs; [ ];

}
