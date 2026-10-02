{pkgs, ...}: {
  hardware = {
    bluetooth = { 
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Experimental = true;
        FastConnectable = "true";
      };
    };
  };
  environment.systemPackages = with pkgs; [ overskride ];
}
