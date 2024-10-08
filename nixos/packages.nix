{
  inputs,
  pkgs,
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Custom
    config.nur.repos.mic92.hello-nur

    # Cli
    ## internet
    aria2
    curl
    wget
    yt-dlp
    rsync
    ani-cli
    mangal
    # (termusic.overrideAttrs (o: {
    #   postPatch =
    #     (o.postPatch or "")
    #     + ''
    #       cp ${./Oxocarbon-Dark.yml} lib/themes
    #     '';
    # }))
    # termusic

    ## bible
    lukesmithxyz-bible-kjv
    grb

    ## unix utils
    ouch
    dust
    duf
    fd
    file
    sd
    navi
    ripgrep
    procs
    rm-improved

    ## helpful
    gcc
    ffmpeg
    imagemagick
    rmpc
    sqlite
    inputs.focal.packages.${pkgs.system}.default
    grimblast
    cliphist
    xdg-utils
    swww
    playerctl
    wl-clipboard
    translate-shell
    pulsemixer
    # nvtopPackages.nvidia
    todo
    pomodoro
    tgpt
    lutgen
    gammastep
    hyprpicker
    wvkbd

    ## nix
    nitch
    nix-output-monitor
    nurl
    nix-tree
    nvd
    sops

    ## compression
    zip
    unzip
    rar
    unrar
    _7zz

    # gui
    calibre
    vesktop
    firefox
    # inputs.zen-browser.packages."${pkgs.system}".specific
    # librewolf
    qbittorrent
    nautilus
    gnome-disk-utility
    qalculate-qt
    geogebra6
    glava
    nsxiv
    # dvd-zig
    gimp

    ## games
    heroic
    prismlauncher
    steam-run
    protonup-qt
    wineWowPackages.waylandFull

    ### emulators
    # wineWowPackages.stable
    # winetricks
    # desmume
    # mgba
    # snes9x-gtk
    #config.nur.repos.chigyutendies.citra-nightly
    #config.nur.repos.chigyutendies.suyu-dev

    # libs
    libnotify
    gtk3
    libsixel
    openssl
    xwayland

    # dev
    ## doom
    (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))
    wordnet
    cmigemo
    ### lsp
    nil
    zls

    ## docs
    man-pages
    man-pages-posix

    ## langs
    python3
    zig

    ## editors
    neovim
    # lem-ncurses
    zed-editor

    # disabled
    #logseq
    #openmw
  ];
}
