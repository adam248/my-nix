# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/framework/16-inch/common/amd.nix>
      <nixos-hardware/framework/16-inch/common>
      ./hardware-configuration.nix
    ];

  # Hardware
  hardware.bluetooth.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    font = "{pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
    fontSize = 32;
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "jan-os"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;

  # Set your time zone.
  time.timeZone = "Australia/Perth";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  console = {
    packages = [ pkgs.terminus_font ];
    font = "{pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Recommended by ChatGPT for auto-mount of usb drives
  services.dbus.enable = true;
  #security.polkit.enable = true;
  services.udisks2.enable = true; 
  

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = { 
    enable = true;
    wayland.enable = true;
    enableHidpi = true;
  };

  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Flatpaks
  services.flatpak.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable fingerprint reader core service
  services.fprintd.enable = true;

  # Enable SSD Drive triming
  services.fstrim.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adam = {
    isNormalUser = true;
    description = "Adam Butler";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  users.users.jan = {
    isNormalUser = true;
    description = "Jan Butler";
    extraGroups = [ 
      "networkmanager" "audio" "video" "plugdev" "lp" "scanner" "cdrom" 
      "power" "users" "uaccess" "upower" "storage" "disk"
      ];
    packages = with pkgs; [
    #  thunderbird
    ];
    linger = true;
  };


  programs.chromium.enable = true;
  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ffmpeg
    kdePackages.ark
    kdePackages.discover
    kdePackages.dolphin
    kdePackages.elisa
    kdePackages.gwenview
    kdePackages.kate
    kdePackages.kcalc
    kdePackages.kinfocenter
    kdePackages.kio-extras
    kdePackages.partitionmanager
    libreoffice
    imagemagick
    neovim
    mpv
    testdisk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  system.copySystemConfiguration = true;
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    allowReboot = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
