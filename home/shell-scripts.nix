{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) writeShellApplication writeShellScriptPlus fd sd;
in {
  home.packages = [
    (
      writeShellApplication {
        name = "template-init";
        runtimeInputs = [fd sd];
        text = ''
          templates_dir=~/thorne/templates
          template_name=$1
          template_url="github:elias-ainsworth/thorne#$template_name"
          available_templates=$(fd --base-directory $templates_dir --type d | sd / "")

          if [ -z "$template_name" ]; then
            echo "error: no template specified" >&2
            echo ""
            echo "Usage: $0 <TEMPLATE>" >&2
            echo ""
            echo "Available Templates:" >&2
            for t in $available_templates; do
              echo "  $t"
            done
            echo ""
            echo "For more information, try '--help'." >&2
            exit 1
          fi
          if ! echo "$available_templates" | grep -q "^$template_name$"; then
              echo "error: template '$template_name' not found" >&2
              echo ""
              echo "Available Templates:" >&2
              for t in $available_templates; do
                  echo "  $t"
              done
              echo ""
              echo "For more information, try '--help'." >&2
              exit 1
          fi

          nix flake init --template "$template_url"
        '';
      }
    )
  ];
}
