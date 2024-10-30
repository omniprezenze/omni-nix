{ pkgs, ... }:
{
  systemd = {
    timers.kb_bluetooth = {
      description = "kb_bluetooth timer";
      wantedBy = [ "timers.target" ];
      partOf = [ "kb_bluetooth.service" ];
      timerConfig = {
        OnUnitActiveSec = "10s";
        Persistent = true;
      };
    };
    services.kb_bluetooth = {
      description = "Connect Bluetooth keyboard";
      path = with pkgs; [ bash bluez ];
      serviceConfig.Type = "simple";
      after = [ "bluetooth.service" ];
      requires = [ "bluetooth.service" ];
      script = ''
        DEVICE_MAC="DC:2C:26:3D:32:E9"

        # Check if the device is connected
        if ! bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
            bluetoothctl connect "$DEVICE_MAC"
        fi
      '';
    };
  };
}
