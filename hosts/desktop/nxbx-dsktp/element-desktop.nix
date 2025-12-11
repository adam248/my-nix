{ pkgs, lib, config, ... }:

with lib;

let
    cfg = config.services.element-desktop;
in {
    options.services.element-desktop = {
        enable = mkEnableOption "Enable Element-Desktop service";
        package = mkOption {
            type = types.package;
            default = pkgs.element-desktop;
            defaultText = "pkgs.element-desktop";
            description = "Set version of fusuma package to use.";
        };
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];
        services.dbus.packages = [ cfg.package ];

        systemd.services.element-desktop = {
            description = "Element-Desktop daemon for autostarting";
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];

            restartIfChanged = true;

            serviceConfig = {
                DynamicUser = true;
                ExecStart = "${cfg.package}/bin/element-desktop";
                Restart = "always";
            };
        };
    };

    meta.maintainers = with lib.maintainers; [];
}
