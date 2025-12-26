{
  config,
  pkgs,
  zen-browser,
  nixdots-assets,
  ...
}:

let
  installCursor =
    name:
    pkgs.stdenv.mkDerivation {
      pname = "cursor-${name}";
      version = "1.0";
      src = "${nixdots-assets}/cursors/${name}";
      installPhase = ''
        mkdir -p $out/share/icons/${name}
        cp -r . $out/share/icons/${name}
      '';
    };
in
{
  home.username = "zedddie";
  home.homeDirectory = "/home/zedddie";

  # backward compatibity version(guide says dont chanfge, in case
  # future me will fporget)
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    vesktop
    telegram-desktop
    obsidian
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    (installCursor "Charlotte-Suzu")
    (installCursor "Hatsune-Miku")
  ];

  home.pointerCursor = {
    package = installCursor "Hatsune-Miku";
    name = "Hatsune-Miku";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  programs.home-manager.enable = true;
}
