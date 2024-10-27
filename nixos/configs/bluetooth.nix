{pkgs, ...}: {
  hardware = {
      bluetooth = { 
        enable = true;
        powerOnBoot = true;
        package = pkgs.bluez;
        settings.General = {
          FastConnectable = "true";
          ReconnectAttempts = "10";
          ReconnectIntervals="1, 2, 3";
        };
      };
  };
  services.blueman.enable = true;
}