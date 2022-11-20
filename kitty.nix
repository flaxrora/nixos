{ pgks, ... }:

let 
  variables = import ./variables.nix;
in {
  environment.etc."kitty.conf".text = ''
    font_size ${variables.font.size}
    font_family ${variables.font.name}

    background ${variables.colors.nord0}
    foreground ${variables.colors.nord6}
    selection_foreground ${variables.colors.nord3}
    selection_background ${variables.colors.nord6}
    url_color ${variables.colors.nord7}
    cursor ${variables.colors.nord8}

    background_opacity 0.9

    color0 ${variables.colors.nord1}
    color1 ${variables.colors.nord11}
    color2 ${variables.colors.nord14}
    color3 ${variables.colors.nord13}
    color4 ${variables.colors.nord9}
    color5 ${variables.colors.nord15}
    color6 ${variables.colors.nord8}
    color7 ${variables.colors.nord5}
    color8 ${variables.colors.nord3}
    color9 ${variables.colors.nord11}
    color10 ${variables.colors.nord14}
    color11 ${variables.colors.nord13}
    color12 ${variables.colors.nord9}
    color13 ${variables.colors.nord15}
    color14 ${variables.colors.nord7}
    color15 ${variables.colors.nord6}
  '';
}