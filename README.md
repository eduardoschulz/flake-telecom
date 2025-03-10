# A repository of flakes to setup the laboratory environment

## Building srsRAN
In this repository you can find three ways to build srsRAN. The first way uses a default.nix file that can be added to the main NixOS configuration or just built in the directory.
### 1st way -- Default.nixv
Add this to your NixOS configuration:
```nix
let srsRAN = pkgs.callPackage ./path-to-default.nix;

in
{
...

```
## Setting up the lab laptops


```shell
sudo nixos-rebuild --flake .#laptop switch

sudo nix build .#hmConfig.laptop.activationPackage && ./result
```

## TODO:
- [x] Package free5gc's gtp5g kernel module
    - [ ] Find out where the module is being installed
    - [ ] Document configuration
- [x] Package a new version of srsRAN
    - [x] Create a flake of srsRAN
    - [x] Create a flake that compiles srsRAN in the src directory
        - [ ] Rewrite to be compatible with other architectures.
- [x] Setup Kubernetes
- [ ] Setup Grafana
- [ ] Setup Prometheus
