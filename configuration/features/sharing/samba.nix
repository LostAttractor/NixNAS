_:
{
  services.samba = {
    enable = true;
    openFirewall = true;

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

  services.samba-wsdd = {
    # make shares visible for Windows clients
    enable = true;
    openFirewall = true;
  };
}