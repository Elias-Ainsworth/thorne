{config, ...}: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      right_format = "$cmd_duration";
      format = "$username$hostname$directory$git_branch$git_state$git_status$nix_shell$direnv$character";

      directory = {
        style = "${config.lib.stylix.colors.withHashtag.base0B}";
        truncation_length = 5;
        truncate_to_repo = false;
      };

      character = {
        # success_symbol = "[λ](${config.lib.stylix.colors.withHashtag.base0A})";
        # error_symbol = "[λ](#FF5C57)";
        # vimcmd_symbol = "[Λ](${config.lib.stylix.colors.withHashtag.base0A})";
        success_symbol = "[ニ](${config.lib.stylix.colors.withHashtag.base0A})";
        error_symbol = "[ニ](#FF5C57)";
        vimcmd_symbol = "[ヰ](${config.lib.stylix.colors.withHashtag.base0A})";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "${config.lib.stylix.colors.withHashtag.base03}";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218)($ahead_behind$stashed)]($style) ";
        style = "${config.lib.stylix.colors.withHashtag.base0C}";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
      git_state = {
        format = "\([$state( $progress_current/$progress_total)]($style)\) ";
        style = "${config.lib.stylix.colors.withHashtag.base03}";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "${config.lib.stylix.colors.withHashtag.base0C}";
      };
      nix_shell = {
        disabled = false;
        pure_msg = "[きよい](${config.lib.stylix.colors.withHashtag.base04})";
        impure_msg = "[けがれ](${config.lib.stylix.colors.withHashtag.base0F})";
        format = "[󱄅 $state](${config.lib.stylix.colors.withHashtag.base09}) ";
      };
      direnv = {
        disabled = false;
        format = "[$symbol$loaded$allowed]($style)";
        # symbol = "ε";
        symbol = "ディレンヴ ";
        style = "${config.lib.stylix.colors.withHashtag.base0E}";
        detect_files = [".envrc"];
        allowed_msg = "​";
        not_allowed_msg = "しようきんし ";
        denied_msg = "きょひ ";
        loaded_msg = "​";
        unloaded_msg = "​";
      };
    };
  };
}
