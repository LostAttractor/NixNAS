{ config, pkgs, lib, ... }:
{
  virtualisation.oci-containers.containers.emby = {
    image = "emby/embyserver";
    environment = {
      UID = "1000"; # The UID to run emby as (default: 2)
      GID = "100"; # The GID to run emby as (default 2)
      GIDLIST = "100"; # A comma-separated list of additional GIDs to run emby as (default: 2)
    };
    volumes = [
      "emby-config:/config"
      "/mnt/Files/Bangumi:/mnt/Bangumi"
      "/mnt/Files/Movies:/mnt/Movies"
      "/mnt/Files/Music:/mnt/Music"
    ];
    ports = [ "8096:8096" ];
    extraOptions = [ "--network=host" ]; # Enable DLNA and Wake-on-Lan
  };

  system.activationScripts.emby = let
    backend = config.virtualisation.oci-containers.backend;
    backendBin = "${pkgs.${backend}}/bin/${backend}";
  in ''
    ${backendBin} volume create ${lib.optionalString (backend == "podman") "--ignore"} emby-config > /dev/null 2>&1
  '';

  services.nginx.virtualHosts."emby.home.lostattractor.net" = {
    locations."/".proxyPass = "http://localhost:8096";
    forceSSL = true;
    enableACME = true;
  };
}