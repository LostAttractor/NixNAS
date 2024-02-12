{ pkgs, user, ... }:

{
  imports = [
    ./features/nix.nix
    ./features/remote-builds.nix
    ./features/prometheus.nix
    ./features/cron.nix
    # Sharing
    ./features/sharing/nfs.nix
    ./features/sharing/samba.nix
    # Services
    ./features/services/nginx.nix
    ./features/services/qbittorrent.nix
    ./features/services/nextcloud.nix
    ./features/services/emby.nix
  ];

  users = {
    # Don't allow mutation of users outside of the config.
    mutableUsers = false;
    # Privilege User
    users.root.openssh.authorizedKeys.keys = [ "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC5HypvbsI4xvwfd4Uw7D+SV0AevYPS/nCarFwfBwrMHKybbqUJV1cLM1ySZPxXcZD7+3m48Riiwlssh6o7WM/M= openpgp:0xDE4C24F6" ];
    # Unprivilege User
    users.${user} = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [ "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC5HypvbsI4xvwfd4Uw7D+SV0AevYPS/nCarFwfBwrMHKybbqUJV1cLM1ySZPxXcZD7+3m48Riiwlssh6o7WM/M= openpgp:0xDE4C24F6" ];
    };
  };

  virtualisation.oci-containers.backend = "docker";

  virtualisation.docker = {
    enable = true;

    daemon.settings = {
      ipv6 = true;
      fixed-cidr-v6 = "2001:db8:1::/64";
      experimental = true;
      ip6tables = true;
    };
  };

  # nixpkgs.config.contentAddressedByDefault = true;

  # Basic Packages
  environment.systemPackages = with pkgs; [ htop btop rsync micro ];

  system.stateVersion = "24.05";
}
