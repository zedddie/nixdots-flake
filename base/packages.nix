{
  pkgs,
  zen-browser,
  ...
}:

{
  home.packages = with pkgs;
    let
      apps = [
        zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        obsidian
        anki-bin
        spotify
        kitty
        krita
      ];
      communication = [
        vesktop
        zed-editor
        zulip
        ayugram-desktop
      ];
      editors = [
        vscodium-fhs
      ];
      dev = [
        rustup
        pkg-config
        nixfmt
        markdownlint-cli
        claude-code
        gcc
        nodejs_24
      ];
      utils = [
        qemu
        arrpc
        xsel
        unzip
        pavucontrol
        ripgrep
        fastfetch
        tealdeer
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
        newsflash
        thunderbird
        obs-studio
      ];
      gaming = [
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
        heroic
        tor-browser
        ipmiview
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
    apps ++ editors ++ communication ++ dev ++ utils ++ wayland ++ secure ++ gaming;
}
