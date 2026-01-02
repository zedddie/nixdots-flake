{ pkgs, ... }: {
  imports = [ ../../base/common-home.nix ];

  home.packages = with pkgs; [ ecl emacs-nox ];
}
