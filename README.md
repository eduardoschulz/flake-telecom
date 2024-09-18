# A Flake to Setup the lab computers 

## Laptops

Before running any of these command change the hostname, ip addresses and kubernetes configuration.

```shell
sudo nixos-rebuild --flake .#laptop switch

sudo nix build .#hmConfig.laptop.activationPackage && ./result
```

## TODO:


- [ ] Package free5gc's gtp5g kernel module
- [ ] Create a flake for OpenAirInterface
    - [ ] package the modified version of asn1c
- [x] Package a new version of srsRAN
    - [ ] Create a flake of srsRAN
- [-] Setup Kubernetes
- [-] Setup Grafana
- [ ] Setup Prometheus
- [ ] Figure out a way to passthrough argument into the config while building
	- [ ] hostname
	- [ ] ip addr
