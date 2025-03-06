{ pkgs, inputs, ... }: {
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    lowLatency = {
      enable = true;
      # defaults (no need to be set unless modified)
      #quantum = 64;
      #rate = 48000;
    };
  };

  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
    helvum # GTK patchbay for pipewire
    qpwgraph # Qt graph manager for PipeWire
  ];
}
