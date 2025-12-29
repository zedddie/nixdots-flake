{
  pkgs,
  ...
}:
{
  imports = [ ../../base/common-home.nix ];

  home.packages = with pkgs; [
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
  ];
}
