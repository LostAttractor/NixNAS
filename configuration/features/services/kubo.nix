_: {
  services.kubo = {
    enable = true;
    dataDir = "/mnt/Files/ipfs";
    autoMount = true;
    localDiscovery = true;
    settings.Addresses.API = "/ip4/127.0.0.1/tcp/5001";
    settings.API.HTTPHeaders = {
      "Access-Control-Allow-Origin" = [
        "https://api.ipfs.home.lostattractor.net"
        "https://webui.ipfs.io"
      ];
      "Access-Control-Allow-Methods" = [
        "PUT"
        "POST"
      ];
    };
  };

  services.nginx.virtualHosts = {
    # API
    "api.ipfs.home.lostattractor.net" = {
      locations."/".proxyPass = "http://localhost:5001";
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        add_header Access-Control-Allow-Origin "https://api.ipfs.home.lostattractor.net";
        add_header Access-Control-Allow-Origin "https://webui.ipfs.io";
        add_header Access-Control-Allow-Methods "PUT";
        add_header Access-Control-Allow-Methods "POST";
      '';
    };
    # Gateway
    "ipfs.home.lostattractor.net" = {
      locations."/".proxyPass = "http://localhost:8080";
      forceSSL = true;
      enableACME = true;
    };
  };

  # Swarm
  networking.firewall = {
    allowedTCPPorts = [ 4001 ];
    allowedUDPPorts = [ 4001 ];
  };
}
