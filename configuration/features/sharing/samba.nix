{ pkgs, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    package = pkgs.sambaFull;

    shares = {
      Files = {
        path = "/mnt/Files";
        public = false;
        writable = true;
      };
      Public = {
        path = "/mnt/Public";
        public = true;
        writable = false;
      };
    };
  };

  # Make shares visible for Windows clients
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
