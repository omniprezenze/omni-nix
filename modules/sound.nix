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
#    lowLatency = { 
#      enable = true;
#      rate = 48000;
#      quantum = 1024;
#    };
  };
  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudio
  ];
}
