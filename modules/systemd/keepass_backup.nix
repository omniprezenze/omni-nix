{ pkgs, ... }:
{
  # RClone Google Drive service
  systemd.services.rclone-gdrive-mount = {
    # Ensure the service starts after the network is up
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];

    # Service configuration
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p /home/omni/gdrive1";
      ExecStart = "${pkgs.rclone}/bin/rclone mount gdrive: /home/omni/gdrive1";
      ExecStop = "/run/current-system/sw/bin/fusermount -u /home/omni/gdrive1";
      Restart = "on-failure";
      RestartSec = "10s";
      User = "omni";
      Group = "users";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ]; # Required environments
    };
  };
}
