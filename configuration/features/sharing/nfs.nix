_:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /srv/nfs        192.168.0.0/16(rw,fsid=root)                           10.100.0.0/24(rw,fsid=root)
      /srv/nfs/Files  192.168.0.0/16(rw,all_squash,anonuid=1000,anongid=100) 10.100.0.0/24(rw,all_squash,anonuid=1000,anongid=100)
    '';
  };

  fileSystems."/srv/nfs/Files" = {
    device = "/mnt/Files";
    options = [ "bind" ];
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
}