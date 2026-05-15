{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.waybar-audio-control;

  toToml =
    { colors, position }:
    ''
      [colors]
      foreground = "${colors.foreground}"
      background = "${colors.background}"
      accent = "${colors.accent}"

      [position]
      anchor = "${position.anchor}"
      margin_top = ${toString position.marginTop}
      margin_right = ${toString position.marginRight}
      margin_bottom = ${toString position.marginBottom}
      margin_left = ${toString position.marginLeft}
    '';
in
{
  options.programs.waybar-audio-control = {
    enable = lib.mkEnableOption "waybar-audio-control";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The waybar-audio-control package to install.";
    };

    colors = {
      foreground = lib.mkOption {
        type = lib.types.str;
        default = "#cdd6f4";
        description = "Text color (hex).";
      };
      background = lib.mkOption {
        type = lib.types.str;
        default = "#1e1e2e";
        description = "Background color (hex).";
      };
      accent = lib.mkOption {
        type = lib.types.str;
        default = "#f5c2e7";
        description = "Highlight/accent color (hex).";
      };
    };

    position = {
      anchor = lib.mkOption {
        type = lib.types.enum [
          "top-left"
          "top-right"
          "bottom-left"
          "bottom-right"
        ];
        default = "top-right";
        description = "Corner anchor for the popup.";
      };
      marginTop = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Top margin in pixels.";
      };
      marginRight = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Right margin in pixels.";
      };
      marginBottom = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Bottom margin in pixels.";
      };
      marginLeft = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Left margin in pixels.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."waybar-audio-control/config.toml".text = toToml {
      inherit (cfg) colors position;
    };
  };
}
