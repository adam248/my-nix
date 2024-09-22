# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  user = "adam"; # currently unused but if you want to use this variable do this: ${user}

  unstableTarball =
    fetchTarball
      "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

  # Unstable packages to be installed with USER
  unstable-pkgs = with pkgs.unstable; [ 
    ardour # Reaper alternative 
    decent-sampler # My very first nixpkgs contrib! Yay!
    discord
    #freecad
    #google-chrome
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    #kicad
    ledger-live-desktop
    muse-sounds-manager
    musescore # musescore 4
    onlyoffice-bin
    #pika-backup # simple backup software deduplicated backups
    #rambox
    telegram-desktop
    tmuxifier
    varia
    #waydroid #need wayland and see the waydroid nix wiki page for more information
  ];

  kde-packages = with pkgs.unstable.kdePackages; [
    kalarm
    kcalc
    kcharselect
    kdenlive
  ];

in

{
  imports = [ 
      ./hardware-configuration.nix # Include the results of the hardware scan.
      <home-manager/nixos> # Include Home Manager - uses home-manager channel (sudo)
    ];


  # Install the latest Linux Kernel available
  # If nothing is specified then the LTS kernal for the current NixOS release is installed
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest; # using unstable due to amdgpu boot issue
  # If mulit--monitor setup is having issues...
  #boot.kernelParams = [
  #  "video=card0-DP-1:2560x1440@144"
  #  "video=card0-HDMI-A-1:2560x1440@60"
  #];

  # set vm.max_map_count for better game experience
  boot.kernel.sysctl = {
    #"vm.max_map_count" = 1048576; # default value
    "vm.max_map_count" = 16777216; # value for Star Citizen
    #"vm.max_map_count" = 2147483642; # value the same as Steam Deck
    "fs.file-max" = 524288; # recommended from star citizen guide
  };

  # SWAP is needed for Star Citizen
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16 GB
  }];

  # ZRAM is recommended for star citizen nixos guide
  zramSwap = { 
    enable = true; 
    memoryMax = 16 * 1024 * 1024 * 1024; # 16 GB ZRAM
  }; 

  # Enable Scarlett 4i4 for Linux
  boot.extraModprobeConfig = ''
    options snd_usb_audio vid=0x1235 pid=0x8212 device_setup=1
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;

  # Only remember this many system configuration changes
  boot.loader.systemd-boot.configurationLimit = 42;
  boot.loader.systemd-boot.enable = true;

  # Install the AMD GPU driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  # OpenCL (Extra GPU Stuff
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true; # Allow 32-bit programs

  networking.hostName = "nxbx-dsktp"; # Define your hostname.

  # Pick only one of the below networking options.
  # {
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # or
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # }
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Set your time zone.
  time.timeZone = "Australia/Perth";

  # Set to Australia locale
  i18n.defaultLocale = "en_AU.UTF-8";
  console = {
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
    #keyMap = "us"; # is being declared elsewhere
    useXkbConfig = true; # use xkbOptions in tty.
  };

  services = {

    ## media server setup notes
    # prowlarr.enable = true; # Jackett replacment
    # prowlarr works with all the following
    # Lidarr (music), Mylar3 (comics), 
    # Radarr (movies), Readarr (books), Sonarr (tv)
    # Readarr works with Calibre
    # All above work with plex
    # https://openaudible.org/ for Audible backup and downloads of audio books
    # Audiobooks in Calibre can be done by adding the audiobook to a zip file
    # then putting the zip file in the Calibre book folder
    # then you get to see the book cover and download the zip file to listen
    # https://github.com/seblucas/cops OPDS server
    # Kavita might be a good Calibre alternative
    # Maybe Jellyfin is best as it could replace plex and calibre???
    # Jellyfin does books and comics!
    # Jellyfin is a fork of emby...

    fstrim.enable = true; # for auto trim of ssds drives

    bitcoind."bitcoind" = {
      enable = false;
      dataDir = "/data/bitcoin";
      extraCmdlineOptions = [ 
        "-maxuploadtarget=1024" # Max 1GB upload per day
        "-maxconnections=25" # Max 25 Connections
        "-blocksonly" # Relay only blocks
        "-maxmempool=50" # Max mempool of 50MB
        "-par=1" # Limit bitcoind to 1 thread
        "-rpcthreads=1" # Limit bitcoind rpc api to 1 thread
      ];
      dbCache = 100; # Limit dbcache size to 100MB
    };

    ratbagd.enable = true; # HID configurator (Logitech mouse) use piper GUI
    
    plex = {
      enable = false; # come on ... get a plex server setup already!!!
      openFirewall = true;
      package = pkgs.unstable.plex;
    };

    displayManager = {
      # Set display manager (login window)
      sddm.enable = true;
      sddm.autoNumlock = true;

      # Enable autologin for a USER
      autoLogin.enable = true;
      autoLogin.user = "adam";

      # plasma 6 on xserver
      defaultSession = "plasmax11";

    };

    # Set a DE (plasma 6+)
    desktopManager.plasma6.enable = true;

    xserver = {

      # Enable the X11 windowing system.
      # Wayland should be considered in the future
      enable = true;

      # Make sure to use AMD
      videoDrivers = [ "amdgpu" ];

      # Set a DE (plasma 5)
      #desktopManager.plasma5.enable = true;


    };
  };

  # Turn On Numlock for all ttys with systemd 
  # It is a good idea to enable Numlock on Login in the DE (KDE) as well
  systemd.services.numLockOnTty = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = lib.mkForce (pkgs.writeShellScript "numLockOnTty" ''
        for tty in /dev/tty{1..6}; do
            ${pkgs.kbd}/bin/setleds -D +num < "$tty";
        done
      '');
      };
  };

  # This is a Hello world systemd service written in bash
  #systemd.services.pointless = {
  #  serviceConfig = {
  #    ExecStart = "/home/adam/code/bash/systemd/pointless.sh";
  #    Restart="always";
  #    User = "adam";
  #    Type = "exec";
  #  };
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;

  # Enable teamviewer
  services.teamviewer.enable = true;

  # Enable KDEConnect
  programs.kdeconnect.enable = true;

  # Enable Firefox
  programs.firefox.enable = true;

  # Enable steam
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
    package = pkgs.steam.override {
      extraPkgs = ps: with ps; [pango harfbuzz libthai];
    };
  };

  programs.gamemode.enable = true;

  # Enable Autojump
  programs.autojump.enable = true;

  # Set the default editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    configure = {
      customRC = ''
        set number relativenumber
        set nu rnu
        set mouse=a
	    set cc=80
	    set nolist
        set nohlsearch
        set nospell
        set tabstop=4
        set shiftwidth=4
        let g:onedark_config = {
          \ 'style': 'darker',
        \}
        colorscheme onedark

        let mapleader = " "

        set clipboard+=unnamedplus

        :nnoremap <leader>f :Telescope find_files<CR>
        :nnoremap <leader>g :Telescope live_grep<CR>
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          vim-floaterm
          onedark-nvim
          vim-nix vim-lua 
          python-syntax
          telescope-nvim telescope-live-grep-args-nvim
          harpoon
          nvim-treesitter.withAllGrammars
          fugitive
          nvim-lint
          {
              plugin = nvim-lspconfig;
              config = ''
                  lua << EOF
                  require('lspconfig').rust_analyzer.setup{}
                  require('lspconfig').tsserver.setup{}
                  EOF
              '';
          }
        ];
      };
    };
  };

  # Bluetooth Configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  # Sound (Pipewire) configuration
  # rtkit is optional but recommended  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # this also enables wireplumber by default
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Enable XBox xbox controllers
  hardware.xpadneo.enable = true;

  # Enable ZSA Moonlander udev rules and such
  hardware.keyboard.zsa.enable = true;

  # Enable Ledger Device
  hardware.ledger.enable = true;

  # Add .local/bin to PATH
  environment.localBinInPath = true;

  # Run Jackett as a service port 9117
  services.jackett.enable = true;

  # Run Trezor Service
  services.trezord.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."adam" = {
    isNormalUser = true;
    extraGroups = [
      "wheel" "video" "audio" "networkmanager" "lp" "scanner" "libvirtd"
      "wireshark" "docker"
    ];
    initialPassword = "adam";
    packages = with pkgs; [
      # Custom Packages
      ## Lutris Override
      (lutris.override {
        extraPkgs = pkgs: [
          # List package dependencies here
          wineWowPackages.stable
          winetricks
        ];
      })

      ## Playwright CLI build
      #(runCommand "wrapped-playwright" { buildInputs = [ makeWrapper ]; }
      #''
      #mkdir -p "$out/bin"
      #makeWrapper "${playwright}/bin/playwright" "$out/bin/playwright" \
      #  --set PLAYWRIGHT_BROWSERS_PATH "${playwright.browsers}"
      #'')

      # this needs a wrapper to run `plasma-discover --backends flathub`
      #libsForQt5.discover


      # Stable Packages
      alsa-lib freetype
      alsa-utils alsa-scarlett-gui # audio management
      audacity
      #authy
      blender
      brave
      dropbox
      element-desktop
      flameshot # screenshots
      gh # Github CLI tool
      gimp
      github-desktop
      gnuradio
      google-chrome
      guitarix # Guitar Amp Emulator
      handbrake
      imagemagick
      inkscape
      keepass xdotool
      keymapp # moonlander ZSA app
      krita
      lazygit
      libreoffice
      neofetch
      obs-studio
      obsidian
      openttd
      oh-my-git
      piper # for my Logitech logitech Mouse - Frontend for ratbagd mouse config daemon (requires services.ratbagd.enable)
      qbittorrent
      qdirstat
      reaper 
      rust-analyzer
      scribus # OSS Alt for Publisher / InDesign / Affinity Designer
      starship # customize shell prompt
      thunderbird
      transcribe
      trezor-suite trezor-udev-rules
      units
      vscode
      xclip # easy copy to clipboard from console
      yt-dlp

      # ASIC Design Software - https://www.youtube.com/watch?v=Eu_crbcBdNM

      #magic-vlsi # VLSI layout tool written in Tcl
      #ngspice # The Next Generation Spice (Electronic Circuit Simulator)
      #xschem #  Schematic capture and netlisting EDA tool

      # Laser cutter/engraving tool
      #lightburn # Layout, editing, and control software for your laser cutter

    ] ++ unstable-pkgs ++ kde-packages;
  };


  home-manager.users."adam" = { pkgs, ... }: {
    home.stateVersion = "23.05";
    home.packages = with pkgs; [
      typst # Modern Markdown to PDF (Better than LaTeX)
    ];
  };

  # Enable Flatpak and helper services
  services.flatpak.enable = true;
  services.dbus.enable = true;
  xdg.portal= {
    enable = true;
    # NOTE: use `xdg-desktop-portal-gtk` if GNOME
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  };

  # Enable auto sudo requests for supported apps
  security.polkit.enable = true;

  # testing out programs or services
  services = {

    # Netdata: Web-based System Monitoring App
    #netdata = {
    #  enable = true;
    #  package = pkgs.unstable.netdataCloud;
    #};

    # Web-based LDAP manager
    #portunus = { 
    #  enable = true;
    #  port = 20000;
    #  ldap.suffix="dc=example,dc=org";
    #};
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Available to all users (including root)
  environment.systemPackages = with pkgs; [
    #bottom # kewler than htop (use btm to run)
    #easyeffects # audio effects for pipewire audio
    #htop
    #python3 --disabled due to build error
    #wireshark --uninstalled as I don't use too often
    bat
    btop # better than btm
    eza #exa replacement # ls replacement
    fd # required for nvim telescope
    ffmpeg
    file
    fzf
    gcc
    git git-lfs
    gparted
    groff # fix for some --help outputs
    kitty # a better terminal emulator
    kup bup # KDE Backup tool & backup + version control
    man # make sure I have man pages available
    mpv
    qpwgraph
    ranger
    ripgrep # required for nvim telescope live-grep
    spice # virt manager helper
    tldr
    tree
    trickle
    unzip
    virt-manager
    vlc
    wget
    zip
  ];

  programs.tmux = {
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
    shortcut = "b"; # this is the default: `Ctrl-b`
    plugins = with pkgs.tmuxPlugins; [
      sensible
      better-mouse-mode
    ];
    extraConfig = ''
      set -g status-keys vi
      set -g mode-keys vi

      # smart pane switching with awareness of vim splits
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';

  };

  # Patch Environment Variables
  environment.sessionVariables = rec {
    # required for Nixified AI's InvokeAI on AMD GPU
    HSA_OVERRIDE_GFX_VERSION = "10.3.0";   
  };
  
  environment.variables = {
      DSSI_PATH   = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
      LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
      LV2_PATH    = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
      LXVST_PATH  = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
      VST_PATH    = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
    };

  # Required Virt-manager Options
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # Install custom fonts
  fonts.packages = with pkgs; [
    nerdfonts
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
  networking.firewall.allowedTCPPorts = [ 
    1234 # for testing dev web sites
    57621 # spotify local discovery
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  # Nix specific settings
  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
    permittedInsecurePackages = [
                "openssl-1.1.1w"
                "openssl-1.1.1u"
                "openssl-1.1.1v"
                "python-2.7.18.6"
                "electron-24.8.6"
              ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nix.settings = {
    substituters = [ "https://nix-citizen.cachix.org" ];
    trusted-public-keys = [ "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo=" ];
  };

  # Automate Nix garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}


