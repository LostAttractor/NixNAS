{ config, ... }:
{
  services.qbittorrent = {
    enable = true;
    webuiPort = 8081;
    torrentingPort = 9179;
    serverConfig = {
      Preferences.WebUI.Password_PBKDF2 = "@ByteArray(5P/EfnMxhqqYzTu5rF//rg==:+tG5V3rzKNOfO/lC5N0g8xeijsgFsqnLdI2sYnK/klhCModR0/1zMoVFv7jmuj3KlsAqV5z92m5rOOiIxYVfZQ==)";
      BitTorrent.Session = {
        DefaultSavePath = "/mnt/Downloads";
        QueueingSystemEnabled = false;
      };
      RSS = {
        AutoDownloader.EnableProcessing = true;
        Session.EnableProcessing = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ config.services.qbittorrent.torrentingPort ];

  services.nginx.virtualHosts."qbittorrent.lostattractor.net" = {
    locations."/".proxyPass = "http://localhost:${toString config.services.qbittorrent.webuiPort}";
    forceSSL = true;
    enableACME = true;
    serverAliases = [ "qbittorrent.home.lostattractor.net" ];
  };
}
