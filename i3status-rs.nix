{ pgks, ... }:

let 
  variables = import ./variables.nix;
in {
  environment.etc."i3status-rs.toml".text = ''
    icons = "awesome"

    [theme]
    name = "nord-dark"

    [theme.overrides]
    separator = ""
    
    [[block]]
    block = "disk_space"
    path = "/"
    alias = "/"
    info_type = "available"
    unit = "GB"
    interval = 20
    warning = 20.0
    alert = 10.0
    
    [[block]]
    block = "memory"
    display_type = "memory"
    format_mem = "{mem_used_percents}"
    format_swap = "{swap_used_percents}"
    
    [[block]]
    block = "cpu"
    interval = 1
    
    [[block]]
    block = "load"
    interval = 1
    format = "{1m}"
    
    [[block]]
    block = "time"
    interval = 5
    format = "%a %d/%m %R"
  '';
}