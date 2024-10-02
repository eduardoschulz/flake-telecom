# A repository of flakes to setup the laboratory environment

## Setting up the lab laptops

Before running any of these command change the hostname, ip addresses, kubernetes configuration and the hardware-configuration.nix file.

```shell
sudo nixos-rebuild --flake .#laptop switch

sudo nix build .#hmConfig.laptop.activationPackage && ./result
```

## Building and Running srsRAN on Nix:

There is 3 ways to build and execute srsRAN_Project on nix following this repo. The first way is to build it like a nixpkg, there is a default.nix inside pkgs, and running as a any other program. The second and third ways are based on flakes. The second way is to just run ```nix build ``` inside ```flakes/srsRAN```, this way you are going to be using the gitfetch function inside the flake to get the repo. Both the first and second ways have the disadvantage of not being able to modified the srsRAN contents. My recommendation it's to either use the second way or the third way.

The third way is the best way if you intend to change some of the code inside the project. Building is the same way but it doesn't fetch anything, you will need to copy the flake-src.nix file and paste it inside the cloned version of srsRAN.

### srsRAN from source (Third Way)
```shell
git clone https://github.com/srsran/srsRAN_Project.git
git clone https://github.com/eduardoschulz/flake-telecom.git

cd srsRAN_Project
cp flake-telecom/flakes/srsRAN/flake-src.nix ./flake.nix

git add flake.nix #you need to to this or else nix won't be able to find this flake
#it will also warn you that the derivation is impure, that's because you didn't commit it to the repo. That's an optional step.

nix build 
#or if you are not runnig with experimetal features enabled
nix build --extra-experimental-features nix-command --extra-experimental-features flakes

cd results/bin/
#Here you should find everything you need.
```

### srsRAN - flake fetch (Second Way)
```shell
git clone https://github.com/eduardoschulz/flake-telecom.git
cd flake-telecom/flakes/srsRAN

nix build 
#or if you are not runnig with experimetal features enabled
nix build --extra-experimental-features nix-command --extra-experimental-features flakes

cd results/bin/
#Here you should find everything you need.
```

### srsRAN - nixpkg (First Way)
```shell
git clone https://github.com/eduardoschulz/flake-telecom.git
cd flake-telecom/pkgs

nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'
#or if you are not runnig with experimetal features enabled
nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' --extra-experimental-features nix-command --extra-experimental-features flakes

cd results/bin/
#Here you should find everything you need.
```


## TODO:


- [x] Package free5gc's gtp5g kernel module
    - [ ] Find out where the module is being installed
    - [ ] Document configuration
- [ ] Create a flake for OpenAirInterface
    - [ ] Package the modified version of asn1c
        - [ ] Fix installation process
- [x] Package a new version of srsRAN
    - [x] Create a flake of srsRAN
    - [x] Create a flake that compiles srsRAN in the src directory
        - [ ] Rewrite to be compatible with other architectures.
- [x] Setup Kubernetes
    - [ ] Write documentation for it
    - [ ] Split kubernetes config from os config
    - [ ] Read [kubenix](https://kubenix.org/)
- [ ] Setup Grafana
- [ ] Setup Prometheus
- [ ] Figure out a way to passthrough argument into the config while building
	- [ ] hostname
	- [ ] ip addr
