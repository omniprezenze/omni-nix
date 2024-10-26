{pkgs, ...}: {
  hardware = {
      bluetooth = { 
        enable = true;
        powerOnBoot = true;
        package = pkgs.bluez;
        settings.General = {
          FastConnectable = "true";
        };
      };
  };
  services.blueman.enable = true;
}