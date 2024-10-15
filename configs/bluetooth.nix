{pkgs, ...}: {
  hardware = {
    bluetooth = { 
      enable = true;
      powerOnBoot = true;
      settings.General = {
        FastConnectable = "true";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    overskride
  ];
}