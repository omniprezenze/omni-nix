{pkgs, inputs, ...}: {
    programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = with pkgs;[
            proton-ge-bin
        ];
        extraPackages = with pkgs; [
            mangohud
        ];
        platformOptimizations.enable = true;
        protontricks.enable = true;
    };
    programs.gamemode = {
        enable = true;
        # settings = {
        #     general.renice = 0;
        #     gpu = {
        #         apply_gpu_optimisations = "accept-responsibility";
        #         gpu_device = 1;
        #         amd_performance_level = "auto";
        #     };
        # };
    };
}