{
  pkgs,
  ...
}:
{
  imports = [ ../../base/common.nix ];

  home.packages = with pkgs; [
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
  ];
}
