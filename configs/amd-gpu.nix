{pkgs, ...}: {

    services.xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
    
    boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}