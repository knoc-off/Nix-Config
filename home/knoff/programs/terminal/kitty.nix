{ pkgs, config, nix-color, lib, ...}:
let
  inherit (config.colorscheme) colors;
in
{
#    sessionVariables = {
#      TERMINAL = "kitty -1";
#    };


  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode"; #config.fontProfiles.monospace.family;# Smart
      size = 15;
    };
    settings = {
      tab_bar_style = "hidden";
      window_padding_width = 5;
      foreground = "#${colors.base06}";
      background = "#${colors.base02}";
      selection_background = "#${colors.base04}";
      selection_foreground = "none";
      url_color = "#${colors.base0D}";
      cursor = "#${colors.base06}";
      #cursor_text_color = "none";
      active_border_color = "#${colors.base03}";
      inactive_border_color = "#${colors.base01}";
      active_tab_background = "#${colors.base02}";
      active_tab_foreground = "#${colors.base06}";
      inactive_tab_background = "#${colors.base01}";
      inactive_tab_foreground = "#${colors.base05}";
      tab_bar_background = "#${colors.base03}";
      # Each of the colors below is paired with a light + dark varient
      ## Black
      color0 = "#${colors.base00}";
      color8 = "#${colors.base03}";

      # Red
      color1 = "#${colors.base10}";
      color9 = "#${colors.base20}";

      # green
      color2 = "#${colors.base17}";
      color10 = "#${colors.base27}";

      # Yellow
      color3 = "#${colors.base14}";
      color11 = "#${colors.base24}";

      # Blue
      color4 = "#${colors.base1A}";
      color12 = "#${colors.base2A}";

      # Magenta
      color5 = "#${colors.base1D}";
      color13 = "#${colors.base2D}";

      # Cyan
      color6 = "#${colors.base18}";
      color14 = "#${colors.base28}";

      # White
      color7 = "#${colors.base07}";
      color15 = "#${colors.base06}";

      mark1_foreground = "#${colors.base01}";
      mark1_background = "#${colors.base0D}"; # light blue
      mark2_foreground = "#${colors.base01}";
      mark2_background = "#${colors.base0A}"; # Beige
      mark3_foreground = "#${colors.base01}";
      mark3_background = "#${colors.base08}"; # Violet

      # IDK:
      color16 = "#${colors.base09}";
      color17 = "#${colors.base0F}";
      color18 = "#${colors.base03}";
      color19 = "#${colors.base04}";
      color20 = "#${colors.base04}";
      color21 = "#${colors.base06}";
    };
  };
}
