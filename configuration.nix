{ lib, pkgs, ... }:

{

  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  # paste your boot config here...
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "nvme" "sd_mod" "sr_mod" ];
  boot.supportedFilesystems = [ "ext4" 	"vfat" "ntfs" "exfat" ];
  boot.kernel.sysctl."vm.swappiness" = 10;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };
  hardware.cpu.amd.updateMicrocode = true;
  system.nixos.tags = [ "external-display" ];

  hardware.graphics.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.uinput.enable = true;
  hardware = {
    nvidia = {
      open = true;
      powerManagement.enable = lib.mkForce false;
      modesetting.enable = true;
      prime = {
        offload.enable = lib.mkForce false;
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:4:0:0";
      };
    };

    amdgpu = {
      amdvlk.enable = false;
      opencl.enable = false;
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    hostName = "lucifer";
    networkmanager.enable = true;
  };

  # edit as per your location and timezone
  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
      LC_CTYPE="en_US.utf8"; # required by dmenu don't change this
    };
  };

  services = {
    xserver = {
      layout = "us";
      xkbVariant = "";
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
        ];
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      displayManager = {
        lightdm.enable = true;
        defaultSession = "xfce+i3";
      };
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };

  # Edit the username below (replace 'neeraj')
  users.users.raghav = {
    isNormalUser = true;
    description = "ragahv";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      xarchiver
      citrix_workspace
      google-chrome
    ];
  };

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 100;
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;
    };
  };

  environment.systemPackages = with pkgs; [
    acpilight
    apfs-fuse
    asusctl
    dbeaver-bin
    ddcutil
    dmenu
    aseqdump
    emacs
    fzf
    home-manager
    hydrogen
    git
    gnome-keyring
    lshw
    lua-language-server
    mangohud
    neofetch
    neovim-unwrapped
    networkmanagerapplet
    nitrogen
    obsidian
    pasystray
    picom
    polkit_gnome
    postgresql_17
    protonup
    pulseaudioFull
    rofi
    ripgrep
    tmux
    transmissions
    unrar
    unzip
    wezterm
    wget
    wine
    xclip
    zoom-us
    linuxKernel.packages.linux_zen.asus-wmi-sensors
  ];


  programs = {
    thunar.enable = true;
    dconf.enable = true;
    firefox.enable = true;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  
  hardware = {
    bluetooth.enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };

  environment.variables = {};
  # Don't touch this
  system.stateVersion = "24.11";
}
