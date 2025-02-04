{ stdenv, lib, fetchFromGitHub, kernel, kmod}:


stdenv.mkDerivation rec {
  pname = "gtp5g";
  version = "1.1"; # Adjust version as necessary

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "gtp5g";
    rev = "v0.9.11";
    sha256 = "sha256-jnme3cOKhNZ1mTVOpSKZioj6u0sh+ZGC1IuzsNsw5Gg=";
  };

 # patches = [ ./nix.patch ];

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
#  installTargets = [ "install" ];
	installPhase = ''

		mkdir -p $out/lib/modules/$kernel.version/kernel/drivers/net
		cp gtp5g.ko $out/lib/modules/$kernel.version/kernel/drivers/net/
	'';

		#modprobe gtp5g


  meta = with lib; {
    description = "GTPv5 Kernel Module";
    license = licenses.gpl3; # or whatever license applies
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
