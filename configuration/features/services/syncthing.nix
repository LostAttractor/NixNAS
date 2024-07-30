{ user, config, ... }:
{
  services.syncthing = {
    enable = true;
    user = user;
  };

  services.nginx.virtualHosts."syncthing.home.lostattractor.net" = {
    locations."/" = {
      recommendedProxySettings = false;
      proxyPass = "http://${config.services.syncthing.guiAddress}";
      # https://docs.syncthing.net/users/faq.html#why-do-i-get-host-check-error-in-the-gui-api
      # 虽然本就是公网可达的, 但的确可以通过更改 nginx 的 host 防止DNS重绑定攻击, 确保只有直接访问 syncthing.home.lostattractor.net 才可达
      extraConfig = ''
        proxy_set_header X-Forwarded-Host ${config.services.syncthing.guiAddress};
      '';
    };
    forceSSL = true;
    enableACME = true;
  };

  # 22000 TCP and/or UDP for sync traffic
  # 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
