{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.stylix.base16Scheme) palette;
in {
  stylix.targets = {
    zathura.enable = false;
    emacs.enable = false;
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk fcitx5-fluent];
  };

  programs = {
    neovide = {
      enable = true;
      settings = {
        srgb = true;
        font = {
          normal = [config.stylix.fonts.monospace.name];
          size = config.stylix.fonts.sizes.terminal;
        };
      };
    };

    # emacs = {
    #   enable = true;
    #   package = pkgs.emacs29-pgtk;
    #   extraPackages = epkgs: [epkgs.vterm];
    # };

    satty = {
      enable = true;
      settings = {
        general = {
          early-exit = true;
          initial-tool = "brush";
          copy-command = "wl-copy";
          annotation-size-factor = 1;
          save-after-copy = false;
          primary-highlighter = "block";
        };
        font.family = config.stylix.fonts.sansSerif.name;
      };
    };

    zathura = {
      enable = true;
      options = with config.lib.stylix.colors.withHashtag; {
        selection-clipboard = "clipboard";
        recolor = "true";
        recolor-keephue = "true";
        font = "${config.stylix.fonts.serif.name} ${toString config.stylix.fonts.sizes.popups}";
        completion-bg = base02;
        completion-fg = base0C;
        completion-highlight-bg = base0C;
        completion-highlight-fg = base02;
        default-fg = base01;
        highlight-active-color = base0D;
        highlight-color = base0A;
        index-active-bg = base0D;
        inputbar-bg = base00;
        inputbar-fg = base04;
        notification-bg = base09;
        notification-error-bg = base08;
        notification-error-fg = base00;
        notification-fg = base00;
        notification-warning-bg = base08;
        notification-warning-fg = base00;
        recolor-darkcolor = base06;
        statusbar-bg = base01;
        default-bg = "rgba(0,0,0,0.7)";
        recolor-lightcolor = "rgba(256,256,256,0)";
      };
      mappings = {
        "h" = "feedkeys '<C-Left>'";
        "j" = "feedkeys '<C-Down>'";
        "k" = "feedkeys '<C-Up>'";
        "l" = "feedkeys '<C-Right>'";
        "i" = "recolor";
        "f" = "toggle_fullscreen";
        "[fullscreen] i" = "recolor";
        "[fullscreen] f" = "toggle_fullscreen";
      };
    };
    kitty = {
      enable = true;
      settings = {
        disable_ligatures = "never";
        cursor_shape = "beam";
        # cursor_blink_interval = "0.5";
        # cursor_stop_blinking_after = "15.0";
        scrollback-lines = 10000;
        click_interval = "0.5";
        select_by_word_characters = ":@-./_~?&=%+#";
        remember_window_size = false;
        visual_bell_duration = "0.0";
        url_style = "double";
        open_url_with = "default";
        confirm_os_window_close = 0;
        enable_audio_bell = false;

        # fixing colorscheme because stylix is a bitch
        background = "#${palette.base00}";
        foreground = "#${palette.base04}";
        color0 = "#${palette.base01}";
        color1 = "#${palette.base0C}";
        color2 = "#${palette.base0D}";
        color3 = "#${palette.base0F}";
        color4 = "#${palette.base0B}";
        color5 = "#${palette.base0A}";
        color6 = "#${palette.base08}";
        color7 = "#${palette.base04}";
        color8 = "#${palette.base02}";
        color9 = "#${palette.base0C}";
        color10 = "#${palette.base0D}";
        color11 = "#${palette.base0F}";
        color12 = "#${palette.base0B}";
        color13 = "#${palette.base0A}";
        color14 = "#${palette.base08}";
        color15 = "#${palette.base06}";
      };
    };
    foot = {
      enable = true;
      settings = {
        main = {pad = "5x5";};
        mouse = {hide-when-typing = "no";};
        key-bindings = {
          scrollback-up-page = "Control+u";
          scrollback-down-page = "Control+d";
          scrollback-up-line = "Mod1+k";
          pipe-command-output = "[wl-copy] Control+Shift+g";
          pipe-scrollback = "[sh -c 'cat > /tmp/comsole'] Control+Shift+f";
          scrollback-down-line = "Mod1+j";
        };
        cursor = {
          style = "beam";
          color = "${palette.base01} ${palette.base05}";
        };
        colors = {
          background = "${palette.base00}";
          foreground = "${palette.base04}";
          regular0 = "${palette.base00}";
          regular1 = "${palette.base0B}";
          regular2 = "${palette.base0C}";
          regular3 = "${palette.base0D}";
          regular4 = "${palette.base07}";
          regular5 = "${palette.base0F}";
          regular6 = "${palette.base09}";
          regular7 = "${palette.base04}";
          bright0 = "${palette.base03}";
          bright1 = "${palette.base0B}";
          bright2 = "${palette.base0C}";
          bright3 = "${palette.base0D}";
          bright4 = "${palette.base07}";
          bright5 = "${palette.base0F}";
          bright6 = "${palette.base09}";
          bright7 = "${palette.base06}";
        };
      };
    };
  };

  services = {
    blueman-applet.enable = true;
    hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = false;
        };
        listener = {
          timeout = 300;
          # on-timeout = "${lib.getExe pkgs.dvd-zig}";
        };
      };
    };
    mako = {
      enable = true;
      defaultTimeout = 5000;
      maxIconSize = 128;
      borderSize = 0;
      format = ''<span foreground="#${palette.base0B}"><b><i>%s</i></b></span>\n<span foreground="#${palette.base0C}">%b</span>'';
      borderRadius = 10;
      padding = "10";
      width = 330;
      height = 200;
    };
  };
}
