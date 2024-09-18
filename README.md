# A Flake to Setup the lab computers 

## Laptops

Before running any of these command change the hostname, ip addresses and kubernetes configuration.

```shell
sudo nixos-rebuild --flake .#laptop switch

sudo nix build .#hmConfig.laptop.activationPackage && ./result
```

## TODO:


- [ ] Package free5gc's gtp5g kernel module
- [-] Create a flake for OpenAirInterface
    - [-] Package the modified version of asn1c
        - [ ] Fix installation process
- [x] Package a new version of srsRAN
    - [x] Create a flake of srsRAN
    - [x] Create a flake that compiles srsRAN in the src directory
        - [-] Rewrite to be compatible with other architectures.
- [-] Setup Kubernetes
- [-] Setup Grafana
- [ ] Setup Prometheus
- [ ] Figure out a way to passthrough argument into the config while building
	- [ ] hostname
	- [ ] ip addr
