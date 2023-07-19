# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Contents (Line Numbers)
#
# Background Services: 100
# Neovim setup: 125
# Sound setup: 165
# Personal Programs: 222
# System-Wide Programs: 300

{ config, pkgs, lib, ... }:

let
  user = "adam"; # currently unused but if you want to use this variable do this: ${user}
  unstableTarball =
    fetchTarball
      "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include Home Manager - uses home-manager channel (sudo)
      <home-manager/nixos>
    ];


  # Install the latest Linux Kernel available
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable Scarlett 4i4
  boot.extraModprobeConfig = ''
    options snd_usb_audio vid=0x1235 pid=0x8212 device_setup=1
  '';

  # Enable emulation of other OS systems &/ architechure
  #boot.binfmt.emulatedSystems = [ "x86_64-windows" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;

  # Only remember this many system configuration changes
  boot.loader.systemd-boot.configurationLimit = 42;
  boot.loader.systemd-boot.enable = true;

  # Install the AMD GPU driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  # OpenCL (Extra GPU Stuff
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
    amdvlk
  ];

  hardware.opengl.driSupport = true;
  # Allow 32-bit programs
  hardware.opengl.driSupport32Bit = true;

  networking.hostName = "nxbx-dsktp"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.enableIPv6 = false;
  #programs.wireshark.enable = true;
  networking.interfaces.enp74s0.ipv4.addresses = [
    {
      address = "192.168.1.42";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  # Set your time zone.
  time.timeZone = "Australia/Darwin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # Set to Australia locale
  i18n.defaultLocale = "en_AU.UTF-8";
  console = {
    packages = [ pkgs.terminus_font ];
    #font = "Lat2-Terminus16";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
    #keyMap = "us"; # is being declared elsewhere
    useXkbConfig = true; # use xkbOptions in tty.
  };

  services = {
    xserver = {

      # Enable the X11 windowing system.
      enable = true;

      # Make sure to use AMD
      videoDrivers = [ "amdgpu" ];

      # Set display manager (login window)
      # testing stability
      #displayManager.lightdm.enable = true;
      # Using Plasma by default
      displayManager.sddm.enable = true;
      displayManager.sddm.autoNumlock = true;
      displayManager.autoLogin.enable = true;
      displayManager.autoLogin.user = "adam";

      # Set desktop manager (full environment)
      desktopManager.plasma5.enable = true;

      # Set window manager (tiling or such)
      # testing stability
      #windowManager.awesome.enable = true;
    };
  };

  systemd.services.numLockOnTty = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # /run/current-system/sw/bin/setleds -D +num < "$tty";
      ExecStart = lib.mkForce (pkgs.writeShellScript "numLockOnTty" ''
        for tty in /dev/tty{1..6}; do
            ${pkgs.kbd}/bin/setleds -D +num < "$tty";
        done
      '');
      };
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;

  # Enable teamviewer
  services.teamviewer.enable = true;

  # Enable file syncing with Syncthing
  #services.syncthing.enable = true;

  # Enable KDEConnect
  programs.kdeconnect.enable = true;

  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

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
          vim-nix vim-lua python-syntax
          telescope-nvim telescope-live-grep-args-nvim
          harpoon
          nvim-treesitter.withAllGrammars
          fugitive
          {
              plugin = nvim-lspconfig;
              config = ''
                  lua << EOF
                  require('lspconfig').rnix.setup{}
                  require('lspconfig').pyright.setup{}
                  require('lspconfig').rust_analyzer.setup{}
                  require('lspconfig').tsserver.setup{}
                  EOF
              '';
          }
        ];
      };
    };
  };

  # Sound Configuration
  hardware.bluetooth.enable = true;

  # Remove sound.enable or turn it off if you had it set previously,
  # it seems to cause conflicts with pipewire
  # Basic
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;


  # Pipewire
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

  # Enable XBox controllers
  hardware.xpadneo.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable VaultWarden
  services.vaultwarden.enable = true;

  # Enable Docker
  #virtualisation.docker.enable = true;

  # Add .local/bin to PATH
  environment.localBinInPath = true;

  # Run Jackett as a service port 9117
  services.jackett.enable = true;

  # Run Trezor Service
  services.trezord.enable = true;

  # Enable Ledger Device
  hardware.ledger.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."adam" = {
    isNormalUser = true;
    extraGroups = [
      "wheel" "video" "audio" "networkmanager" "lp" "scanner" "libvirtd"
      "wireshark"
    ];
    initialPassword = "adam";
    packages = with pkgs; [
      # Custom playwright build
      #(runCommand "wrapped-playwright" { buildInputs = [ makeWrapper ]; }
      #''
      #mkdir -p "$out/bin"
      #makeWrapper "${playwright}/bin/playwright" "$out/bin/playwright" \
      #  --set PLAYWRIGHT_BROWSERS_PATH "${playwright.browsers}"
      #'')

      cutter ghidra # reverse engineering tools

      flameshot # screenshots
      alsa-utils alsa-scarlett-gui # audio management
      alsa-lib freetype
      pavucontrol # pusleaudio control GUI

      # network tools
      ethtool
      iperf
      dig # enables nsloopup for DNS checking

      github-desktop
      lazygit
      qdirstat
      xclip # easy copy to clipboard from console
      firefox
      unstable.google-chrome
      thunderbird
      element-desktop
      keepass xdotool
      vscode
      vlc
      #spotifyd # use the services.spotifyd.enable
      unstable.rambox
      agenda
      obsidian

      gimp
      audacity
      blender
      unstable.godot_4
      obs-studio

      krita

      #davinci-resolve
      libsForQt5.kdenlive

      reaper 

      unstable.musescore # musescore 4

      unstable.cups-pdf-to-pdf

      (lutris.override {
        extraPkgs = pkgs: [
          # List package dependencies here
          wineWowPackages.stable
          winetricks
        ];
      })
      phoronix-test-suite
      starship # customize shell prompt
      dropbox
      libsForQt5.kalendar
      bottles # Wineprefix manager
      neofetch
      inkscape
      imagemagick
      unstable.onlyoffice-bin
      scribus
      libreoffice
      youtube-dl
      unstable.carla # audio plugin manager
      #airwave #<- broken, needs third-party install
      #notepadqq #<- broken
      gh # Github CLI tool
      libsForQt5.kcharselect
      discord
      qbittorrent
      unstable.exodus
      trezor-suite
      trezor-udev-rules
      ffmpeg
      imagemagick
      unstable.ledger-live-desktop
      vmpk # Virtual MIDI Piano Keyboard
      electrum
      qsynth # Audio Synth Emulator
      guitarix # Guitar Amp Emulator
      authy
      unstable.ardour
      units

      libsForQt5.kcalc

      unstable.localsend

      unstable.kicad

      #unstable.freecad # free alt to Fusion360

      rnix-lsp
      rust-analyzer
    ];
  };

  home-manager.users."adam" = { pkgs, ... }: {
    home.stateVersion = "23.05";
    home.packages = with pkgs; [
      typst
    ];
  };

  # Enable Flatpak
  services.flatpak.enable = true;
  services.dbus.enable = true;
  xdg.portal= {
    enable = true;
    # NOTE: use `xdg-desktop-portal-gtk` if GNOME
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  };

  security.polkit.enable = true;

  # testing out programs or services
  services = {
    prometheus = {
      enable = true;
    };
    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
        };
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Available to all users (including root)
  environment.systemPackages = with pkgs; [
    bat
    bottom # kewler than htop (use btm to run)
    clinfo # GPU extras
    exa
    fd # required for nvim telescope
    ffmpeg
    file
    gcc
    git
    gotop # vtop
    groff # fix for some --help outputs
    htop
    kitty # a better terminal emulator
    kup bup # KDE Backup tool & backup + version control
    links2 # CLI Web Browser
    linvstmanager
    man # make sure I have man pages available
    nvtop # GPU
    pciutils # required for lspci,
    python3
    qpwgraph
    ranger
    ripgrep # required for nvim telescope live-grep
    station # rambox competitor
    surge surge-XT
    tldr
    tree
    unzip
    virt-manager
    w3m
    wget
    wireshark
    yabridge yabridgectl
    zip
    zoom-us
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
  fonts.fonts = with pkgs; [
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
    allowReboot = true;
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
                "openssl-1.1.1u"
                "python-2.7.18.6"
              ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # Automate Nix garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}


