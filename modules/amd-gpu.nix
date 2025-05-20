{ pkgs, ...}: {
    
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  environment = {
    systemPackages = with pkgs; [
      amdgpu_top
    ];
  };

  # services = { 
  #   ollama = {
  #     enable = true;
  #     acceleration = "rocm";
  #     openFirewall = true;
  #     rocmOverrideGfx = "11.0.0";
  #     loadModels = [ "deepseek-r1:32b" ];
  #     host = "0.0.0.0";
  #   };
  #   open-webui = {
  #     enable = true;
  #     host = "0.0.0.0";
  #     openFirewall = true;
  #     port = 9443;
  #   };
  # };
}
