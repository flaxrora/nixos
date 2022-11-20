{ pgks, ... }:

let 
  variables = import ./variables.nix;
in {
  services.samba = {
    enable = true;
    extraConfig = ''
      # This setting controls the minimum protocol version that the server
      # will allow the client to use.
      min protocol = SMB2

      # Apple extensions require support for extended attributes(xattr)
      ea support = yes
      
      null passwords = yes

      # Load in modules (order is critical!) and enable AAPL extensions
      vfs objects = catia fruit streams_xattr

      # Enable Apple's SMB2+ extension codenamed AAPL
      fruit:aapl = yes

      # Store OS X metadata by passing the stream on to the next module in the
      # VFS stack (see vfs objects)
      fruit:metadata = stream

      # Defines the model string inside the AAPL extension and will determine
      # the appearance of the icon representing the Samba server in the Finder
      # window
      fruit:model = MacSamba

      # Whether to enable POSIX directory rename behaviour for OS X clients.
      # Without this, directories can't be renamed if any client has any file
      # inside it (recursive!) open.
      fruit:posix_rename = yes

      # Whether to return zero to queries of on-disk file identifier, if the client has negotiated AAPL.
      fruit:zero_file_id = yes

      fruit:veto_appledouble = no

      fruit:wipe_intentionally_left_blank_rfork = yes
      fruit:delete_empty_adfiles = yes
    '';

    shares = {
      code = {
        path = "/home/${variables.username}/code";
        public = "no";
        writeable = "yes";
        browseable = "yes";
        "force user" = "${variables.username}";
        "force group" = "users";
        "follow symlinks" = "yes";
        "valid users" = "${variables.username}";
        "vfs objects" = "catia fruit streams_xattr";
        "wide links" = "yes";
      };
      nixos = {
        path = "/etc/nixos";
        public = "no";
        writeable = "yes";
        browseable = "yes";
        "force user" = "root";
        "force group" = "root";
        "follow symlinks" = "no";
        "valid users" = "${variables.username}";
        "vfs objects" = "catia fruit streams_xattr";
        "wide links" = "no";
      };
    };
  };
}
