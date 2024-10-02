# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, kernel, hostname, ipAddress, ... }:
let
  _ = if hostname == null then
      throw "Invalid hostname, use --arg hostname 'example'."
  else if ipAddress == null then
      throw "Invalid IP address, use --arg ipAddress '192.168.1.1'."
  else
      {
      };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/kubernetes.nix #I don't know if this works because of the arguments
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; #enables flakes and nix commands without needing to pass an extra argument.
  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev"; #must be set up to nodev if uefi
  boot.loader.grub.useOSProber = true;


    /*
        I'll probably define this networking block later under modules/networking.nix or something...
    */

  networking = {
    hostName = hostname; 
    usePredictableInterfaceNames = true;

    interfaces = {
	eth0.ipv4.addresses = [{
		address = ipAddress; 
		prefixLength = 23; # the right thing to do here is to receive a ip/netmask, and then splited but i'm not going to do that right now.
		}];
	};
    defaultGateway = {
        address = "191.4.204.1"; 
	interface = "eth0";
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Enable networking
    networkmanager.enable = true;
  };



   /*
        I'll probably define this as a locale.nix sometime.
    */

   # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "thinkpad";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.demo = {
    isNormalUser = true;
    description = "demo";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.xserver = {

     enable = true;
     displayManager.gdm.enable = true;
     desktopManager.gnome.enable = true;
};
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     kompose
     kubectl
		 git
  ];


   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;


  virtualisation.docker = {
    enable = true;
  };

  services.grafana = {
    enable = true;
		domain = "grafana.demo3";
		port = 3000;
		addr = "191.4.204.204";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).


  system.stateVersion = "24.05"; # Did you read the comment?

}
