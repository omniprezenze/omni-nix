{ pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/Podman
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    #https://wiki.nixos.org/wiki/Libvirt
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;
  users.users.omni.extraGroups = [ "podman" "libvirtd" ];

}