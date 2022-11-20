{ config, pkgs, ... }:

let 
  variables = import ./variables.nix;
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./avahi.nix
      ./samba.nix
      ./i3.nix
      ./i3status-rs.nix
      ./kitty.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.opengl.enable = true;

  time.timeZone = "America/Los_Angeles";

  # Default user fetched from variables
  # -- initial password is same with hostname // change password after install
  users.users.${variables.username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "docker" ];
    initialPassword = variables.hostname;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.pathsToLink = [ "/libexec" ]; # looks like required for i3 blocks
  
  environment.variables = {
    LIBGL_ALWAYS_SOFTWARE = "1"; # hardware rendering on qemu is not working well
    TERMINAL = "kitty";
    KITTY_CONFIG_DIRECTORY = "/etc";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    tig
    wget
    htop
    file
    fish
    tmux
    jq
    killall
    xclip

    gnupg
    pass

    deno    
    nodejs
    docker-compose
    
    gtkmm3
    cifs-utils
    qemu-utils
    spice-vdagent
    davfs2
    kitty
    qutebrowser

    nordic
    libnotify
  ];
  
  networking = {
    hostName = variables.hostname; # Define your hostname.
  
    useDHCP = false; # Keep here for backward compatibility
    # interfaces.enp0s8.useDHCP = true; # Keep here for future compatibility

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        8080
        # 443 
        445 # samba
        139 # samba
      ];
      allowedUDPPorts = [
        137 # samba
        138 # samba
      ];
    };
  };

  services = {
    openssh.enable = true; 
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  
    xserver = {
      enable = true;
      # dpi = 220;   
      
      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "scale";
      };
     
      displayManager = {
        defaultSession = "none+i3";
        sessionCommands = ''
          ${pkgs.xlibs.xset}/bin/xset r rate 200 40
          ${pkgs.spice-vdagent}/bin/spice-vdagent
        '';

        autoLogin = {
          enable = true;
          user = "${variables.username}";
        };
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        configFile = "/etc/i3.conf";
        extraPackages = with pkgs; [
          dmenu # application launcher most people use
          # i3status # gives you the default i3 status bar
          i3status-rust
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
        ];
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d '${config.services.samba.shares.code.path}' 0755 '${config.services.samba.shares.code."force user"}' '${config.users.users.${config.services.samba.shares.code."force user"}.group}' - -"
  ];

  programs.fish.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

  fonts.fonts = with pkgs; [
    font-awesome
    font-awesome_4
    jetbrains-mono
    google-fonts
  ];

  system.stateVersion = "21.05"; 
}
