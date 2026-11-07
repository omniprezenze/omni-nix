{ pkgs, ...}: {
    
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.overdrive.enable = true;
  };
  
  environment = {
    systemPackages = with pkgs; [
      amdgpu_top
      (writeShellScriptBin "amdgpu-tui" ''
        exec ${ghostty}/bin/ghostty --title=amdgpu_top-tui -e ${amdgpu_top}/bin/amdgpu_top --dark
      '')
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
