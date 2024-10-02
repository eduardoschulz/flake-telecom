# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ipAddress, hostname, osConfig, ... }:

let
 	hostname = " ";
	ipAddress = " ";
 # _ = if hostname == null then
 #     throw "Invalid hostname, use --arg hostname 'example'."
 # else if ipAddress == null then
      #throw "Invalid IP address, use --arg ipAddress '192.168.1.1'."
  #else
  #    {};

/* { config, pkgs, kernel, ipAdress, hostname, ... }:
let

  _ = if hostname == null then
      throw "Invalid hostname, use --arg hostname 'example'."
  else if ipAddress == null then
      throw "Invalid IP address, use --arg ipAddress '192.168.1.1'."
  else
      {
      }; */
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; #enables flakes and nix commands without needing to pass an extra argument.
  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev"; #must be set up to nodev if uefi
  boot.loader.grub.useOSProber = true;

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


  virtualisation.docker = {
    enable = true;
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).


  system.stateVersion = "24.05"; # Did you read the comment?

}
