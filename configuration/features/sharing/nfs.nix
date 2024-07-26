_: {
  services.nfs.server = {
    enable = true;
    exports = ''
      /srv/nfs        10.0.0.0/8(rw,fsid=root)
      /srv/nfs/Files  10.0.0.0/8(rw,all_squash,anonuid=1000,anongid=100)
    '';
  };

  fileSystems."/srv/nfs/Files" = {
    device = "/mnt/Files";
    options = [ "bind" ];
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
