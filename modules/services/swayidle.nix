{ config, pkgs, ... }:
{  
	systemd.user.services = {
    swayidle-c = {
      path = with pkgs; [ swaylock-effects sway ];
			documentation = [ "man:swayidle(1)" ];
			partOf = [ "sway-session.target" ];
			requires = [ "sway-session.target" ];
			after = [ "sway-session.target" ];
			wantedBy = [ "sway-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.swayidle}/bin/swayidle -w";
      };
    };
  };
}