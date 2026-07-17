{
  nixdots-assets,
  pkgs,
  zen-browser,
  helix-steel,
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
  home.packages = with pkgs;
    let
      apps = [
        zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        obsidian
        anki-bin
        spotify
        kitty
        ghostty
        newsflash
        peaclock
        krita
        (installCursor "Yuurei-Angel")
      ];
      communication = [
        vesktop
        zed-editor
        zulip
        ayugram-desktop
      ];
      editors = [
        vscodium-fhs
        vscode-fhs
        helix-steel.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      dev = [
        zls
        clang-tools
        rustup
        pkg-config
        nixfmt
        markdownlint-cli
        claude-code
        gcc
        nodejs_26
      ];
      utils = [
        qemu
        bat
        arrpc
        xsel
        unzip
        pavucontrol
        ripgrep
        fastfetch
        tealdeer
        ipmiview
      ];
      wayland = [
        slurp
        grim
        wl-clipboard
      ];
      secure = [
        keychain
        keepassxc
        gnupg
      ];
      rev = [
        ghidra
        iaito
      ];
      misc = [
        thunderbird
        obs-studio
      ];
      gaming = [
        heroic
        mangohud
        prismlauncher
      ];
      unused = [
        fluffychat
        gajim
        dino
        qtox
        psi-plus
        protonup-qt
        lutris
        bottles
        tor-browser
        ticktick
        alacritty
        st
        helix
        xwayland-satellite
        waybar
        rofi
        swww
        wl-color-picker
        dunst
      ];
    in
    apps ++
    editors ++
    communication ++
    dev ++
    utils ++
    wayland ++
    secure ++
    gaming;
}
