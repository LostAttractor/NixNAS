{
  config,
  pkgs,
  lib,
  ...
}:
{
  virtualisation.oci-containers.containers.emby = {
    image = "emby/embyserver";
    volumes = [
      "emby-config:/config"
      "/mnt/Bangumi:/mnt/Bangumi"
      "/mnt/Movies:/mnt/Movies"
      "/mnt/Music:/mnt/Music"
    ];
    extraOptions = [ "--network=host" ]; # Enable DLNA and Wake-on-Lan
  };

  system.activationScripts.emby =
    let
      backend = config.virtualisation.oci-containers.backend;
      backendBin = "${pkgs.${backend}}/bin/${backend}";
    in
    ''
      ${backendBin} volume create ${
        lib.optionalString (backend == "podman") "--ignore"
      } emby-config > /dev/null 2>&1
    '';

  services.nginx.virtualHosts."emby.lostattractor.net" = {
    locations."/" = {
      proxyPass = "http://localhost:8096";
      proxyWebsockets = true;
    };
    forceSSL = true;
    enableACME = true;
    serverAliases = [ "emby.home.lostattractor.net" ];
  };
}
