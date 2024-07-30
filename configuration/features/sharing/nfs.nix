_: {
  # https://github.com/sffjunkie/nixos/blob/main/configuration/module/machine/storage/nfs/default.nix#L23
  services.nfs = {
    server = {
      enable = true;
      exports = ''
        /srv/nfs        10.0.0.0/8(rw,fsid=root)
        /srv/nfs/Files  10.0.0.0/8(rw,all_squash,anonuid=1000,anongid=100)
      '';
    };
    settings.nfsd.rdma = true;
  };

  fileSystems."/srv/nfs/Files" = {
    device = "/mnt";
    options = [ "bind" ];
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
