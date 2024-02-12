{ config, pkgs, ... }:
{
  environment.etc."nextcloud-admin-pass".text = "123456";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    config.adminpassFile = "/etc/nextcloud-admin-pass";

    hostName = "nextcloud.home.lostattractor.net";
    https = true;
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}