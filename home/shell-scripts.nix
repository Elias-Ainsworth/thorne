{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) writeShellScriptBin writeShellScript writeShellScriptPlus fd sd;
  _ = lib.getExe;
in {
  template-init = writeShellScript {
    name = "template-init";
    text = ''
      templates_dir=~/thorne/templates
      template_name=$1
      template_url="github:elias-ainsworth/thorne#$template_name"
      available_templates=$(${_ fd} --base-directory $templates_dir --type d | ${_ sd} / "")

      if [-z "$template_name"]; then
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
  };
}
