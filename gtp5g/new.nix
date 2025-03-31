{ stdenv, lib, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  pname = "gtp5g";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "gtp5g";
    rev = "v${version}";
    sha256 = "n4YhgySVjceRRHxoaGd4Z+Rf2MgD6+upZTcS6xMLLJ0=";
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
    cp gtp5g.ko $out/lib/modules/${kernel.modDirVersion}/extra/
  '';

  meta = with lib; {
    description = "GTPv5 Kernel Module";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
