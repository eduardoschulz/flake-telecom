{...}:
{
  networking = {
    hostName = "demo3"; 
    usePredictableInterfaceNames = true;

    interfaces = {
	eth0.ipv4.addresses = [{
		address = "191.4.204.204"; 
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
		firewall.enable = false;
  };

}
