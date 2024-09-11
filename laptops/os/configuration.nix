# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  kubeMasterIP = "191.4.204.200"; 
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 6443;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking = {
    hostName = "demo0"; # Define your hostname.
    usePredictableInterfaceNames = true;

    wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    interfaces = {
	eth0.ipv4.addresses = [{
		address = "191.4.204.200"; #change this for every host!!
		}];
	};
    defaultGateway = {
        address = "191.4.204.1";
	interfaces = "eth0";
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Enable networking
    networkmanager.enable = false;
  };
  #
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    variant = "";
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
     kubernetes
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
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  # Kubernetes Configuration
  # Master Node

    networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";

    services.kubernetes = {
      roles = ["master" "node"];
      #roles = ["node"]; #For Node, comment the line above.
      masterAddress = kubeMasterHostname;
      apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
      easyCerts = true;
	
      apiserver = { #comment this if node
        securePort = kubeMaterAPIServerPort; #comment this if node
	advertiseAddress = kubeMasterIP; #comment this if node
      };

      #kubelet.kubeconfig.server = api; #uncomment this if node
      #apiserverAddress = api; #uncomment this if node

      addons.dns.enable = true;
      kubelet.extraOpts = "--fail-swap-on=false";
    };

  ## For the connection between the node and master node run this aswell:
  # cat /var/lib/kubernetes/secrets/apitoken.secret #on master node
  # echo TOKEN | nixos-kubernetes-node-join #on worker node

  virtualisation.docker = {
    enable = true;
  };


  system.stateVersion = "24.05"; # Did you read the comment?

}
