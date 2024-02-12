{ pkgs, user, ... }:
{
  systemd.services.qbittorrent-nox = { 
    description = "qBittorrent-nox service for user ${user}"; 

    wants = ["network-online.target"]; 
    after = ["local-fs.target" "network-online.target" "nss-lookup.target"]; 
    wantedBy = ["multi-user.target"];

    serviceConfig = { 
      Type = "simple";
      PrivateTmp = "false";
      User = "${user}"; 
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox"; 
      TimeoutStopSec = 1800; 
    };
  };

  services.nginx.virtualHosts."qbittorrent.home.lostattractor.net" = {
    locations."/".proxyPass = "http://localhost:8080";
    forceSSL = true;
    enableACME = true;
  };
}