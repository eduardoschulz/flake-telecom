{ stdenv, lib, fetchFromGitHub, kernel, kmod }:


stdenv.mkDerivation rec {
  pname = "gtp5g";
  version = "1.0"; # Adjust version as necessary

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "gtp5g";
    rev = "v0.9.1";
    sha256 = "89fa028f620f023da5ae132a1724eba7df8eb526";
  };

 # patches = [ ./nix.patch ];

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  installTargets = [ "install" ];


  meta = with lib; {
    description = "GTPv5 Kernel Module";
    license = licenses.gpl3; # or whatever license applies
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

