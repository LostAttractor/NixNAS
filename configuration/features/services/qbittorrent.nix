{ user, config, ... }:
{
  services.qbittorrent = {
    enable = true;
    webuiPort = 8081;
    torrentingPort = 9179;
    user = user;
    group = config.users.users.${user}.group;
    serverConfig = {
      Preferences.WebUI.Password_PBKDF2 = "@ByteArray(5P/EfnMxhqqYzTu5rF//rg==:+tG5V3rzKNOfO/lC5N0g8xeijsgFsqnLdI2sYnK/klhCModR0/1zMoVFv7jmuj3KlsAqV5z92m5rOOiIxYVfZQ==)";
      BitTorrent.Session.DefaultSavePath = "/mnt/Files/Downloads";
      RSS = {
        AutoDownloader.EnableProcessing = true;
        Session.EnableProcessing = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ config.services.qbittorrent.torrentingPort ];

  services.nginx.virtualHosts."qbittorrent.home.lostattractor.net" = {
    locations."/".proxyPass = "http://localhost:${toString config.services.qbittorrent.webuiPort}";
    forceSSL = true;
    enableACME = true;
  };
}