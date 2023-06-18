{ pkgs ? import <nixpkgs> {} 
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

pkgs.dockerTools.buildImage {
    name = "mosquitto-docker";
    config = {
        Cmd = [ "${pkgsLinux.mosquitto}/bin/mosquitto" ];
    };
}