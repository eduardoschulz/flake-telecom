# A Flake to Setup the lab computers 

## Laptops

Before running any of these command change the hostname, ip addresses and kubernetes configuration.

```shell
sudo nixos-rebuild --flake .#laptop switch

sudo nix build .#hmConfig.laptop.activationPackage && ./result
```

## TODO:


- [ ] Package free5gc kernel module
- [ ] Create a flake for OpenAirInterface
- [ ] Package openairinterface5g
    - [ ] Package a different version of asn1c
- [ ] Package a new version of srsRAN
- [ ] Setup Kubernetes
- [x] Setup Grafana
	- [ ] fix renaming grafana demo3
- [ ] Setup Prometheus
- [ ] Figure out a way to passthrough argument into the config while building
	- [ ] hostname
	- [ ] ip addr
