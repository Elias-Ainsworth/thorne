{config, ...}: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      right_format = "$cmd_duration";
      format = "$username$hostname$directory$git_branch$git_state$git_status$direnv$character";

      directory = {
        style = "${config.lib.stylix.colors.withHashtag.base0B}";
        truncation_length = 5;
        truncate_to_repo = false;
      };

      character = {
        success_symbol = "[λ](${config.lib.stylix.colors.withHashtag.base0A})";
        error_symbol = "[λ](#FF5C57)";
        vimcmd_symbol = "[Λ](${config.lib.stylix.colors.withHashtag.base0A})";
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
      direnv = {
        disabled = false;
        format = "[$symbol$loaded$allowed]($style) ";
        symbol = "ε";
        style = "${config.lib.stylix.colors.withHashtag.base0E}";
        detect_files = [".envrc"];
        allowed_msg = "​";
        denied_msg = "not-allowed";
        loaded_msg = "​";
        unloaded_msg = "​";
      };
    };
  };
}
