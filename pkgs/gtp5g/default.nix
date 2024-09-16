{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation {
  name = "gtp5g";
  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "gtp5g";
    rev = "v0.9.1";
    sha256 = "89fa028f620f023da5ae132a1724eba7df8eb526";
  };

  buildInputs = [ kernel ];

  buildPhase = ''
    make clean
    make
  '';

  #make install 
  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.version}/extra
    cp -r my_module.ko $out/lib/modules/${kernel.version}/extra/
  '';

  meta = with stdenv.lib; {
    description = "free5gc's gtp5g kernel module";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

