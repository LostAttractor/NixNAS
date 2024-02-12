{ config, pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    config.adminpassFile = "${pkgs.writeText "adminpass" "123456"}";

    config.dbtype = "pgsql";
    database.createLocally = true;
    configureRedis = true;

    notify_push.enable = true;

    # datadir = "/mnt/Files/Nextcloud";

    hostName = "nextcloud.home.lostattractor.net";
    https = true;
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}