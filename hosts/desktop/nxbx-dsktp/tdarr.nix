# /etc/nixos/tdarr.nix
{ config, lib, pkgs, ... }:

let
  # --- tweak these to match your system ---
  tdarrUserUid = 1000;                # your user UID
  tdarrUserGid = 1000;                # your user GID
  tdarrDataDir = "/var/lib/tdarr";    # where Tdarr will persist configs/logs/cache
  mediaRoot    = "/data/Downloads/";        # your library root (host path)
in
{
  # Enable Podman (recommended)
  virtualisation = {
    containers.enable = true;         # common /etc/containers config (Podman)
    podman.enable = true;

    oci-containers = {
      backend = "podman";             # set to "docker" if you prefer Docker

      containers.tdarr = {
        image = "haveagitgat/tdarr:latest";
        autoStart = true;

        # WebUI 8265, Server 8266
        ports = [ "8265:8265" "8266:8266" ];

        # Persist config/logs/cache and mount your media
        volumes = [
          "${tdarrDataDir}/config:/app/configs"
          "${tdarrDataDir}/logs:/app/logs"
          "${tdarrDataDir}/cache:/temp"
          "${mediaRoot}:/media"
        ];

        environment = {
          TZ = "Australia/Perth";
          PUID = toString tdarrUserUid;
          PGID = toString tdarrUserGid;

          # Server settings per Tdarr docs
          serverIP   = "0.0.0.0";
          webUIPort  = "8265";
          serverPort = "8266";

          # enable the built-in worker (node) inside the server container
          internalNode = "true";
          nodeName = "MyInternalNode";
          inContainer = "true";

          # Optional: pin ffmpeg version inside container
          # ffmpegVersion = "6";
        };

        # GPU passthrough (uncomment what you use):

        # -- Intel/AMD VAAPI (typical):
        extraOptions = [
          "--device=/dev/dri"
          # "--device=/dev/kfd"   # some AMD setups (ROCm) may need this
        ];

        # -- NVIDIA (requires NVIDIA Container Toolkit on host):
        # extraOptions = [ "--gpus=all" ];
        # environment = environment // {
        #   NVIDIA_VISIBLE_DEVICES = "all";
        #   NVIDIA_DRIVER_CAPABILITIES = "compute,video,utility";
        # };
      };
    };
  };

  # Ensure persistence dirs exist with the right ownership
  systemd.tmpfiles.rules = [
    "d ${tdarrDataDir}            0755 ${toString tdarrUserUid} ${toString tdarrUserGid} -"
    "d ${tdarrDataDir}/config     0755 ${toString tdarrUserUid} ${toString tdarrUserGid} -"
    "d ${tdarrDataDir}/logs       0755 ${toString tdarrUserUid} ${toString tdarrUserGid} -"
    "d ${tdarrDataDir}/cache      0755 ${toString tdarrUserUid} ${toString tdarrUserGid} -"
  ];
}

