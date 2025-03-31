# A repository of flakes to setup the laboratory environment

## Building srsRAN
In this repository you can find three ways to build srsRAN.

### 1st way -- Default.nix
Add this to your NixOS configuration:
```nix
let srsRAN = pkgs.callPackage ./path-to-default.nix;

in
{
...
```
### 2nd way -- flake
Create a empty directory for srsRAN and copy the flake.nix from srsRAN/flake/flake.nix.
```shell
nix build
cd results/
```
### 3rd way -- flake from source
Clone srsRAN from github and copy flake-src.nix. Rename flake-src.nix to flake.nix.
```
git clone https://github.com/srsran/srsRAN_Project
cp flake-telecom/srsRAN/flake/flake-src.nix srsRAN_Project/flake.nix
cd srsRAN_Project && git add .
git commit -m "adding flake"

nix build
```

## Gtp5g module

To build this module simply insert the configurations found in the hardware-configurations.nix found at laptops/os/.
After adding to your NixOS configurations don't forget to run a nixos-rebuild switch and manually load the module with modprobe.


## Setting up the lab laptops


```shell
sudo nixos-rebuild --flake .#laptop switch

sudo nix build .#hmConfig.laptop.activationPackage && ./result
```

## TODO:
- [x] Package free5gc's gtp5g kernel module
- [x] Package a new version of srsRAN
    - [x] Create a flake of srsRAN
    - [x] Create a flake that compiles srsRAN in the src directory
        - [ ] Rewrite to be compatible with other architectures.
- [x] Setup Kubernetes
