_: {
  services.nginx.virtualHosts."immich.lostattractor.net" = {
    locations."/" = {
      proxyPass = "http://localhost:2283";
      proxyWebsockets = true;
    };
    forceSSL = true;
    enableACME = true;
    extraConfig = ''
      client_max_body_size 50000M;
    '';
    serverAliases = [ "immich.home.lostattractor.net" ];
  };
}
