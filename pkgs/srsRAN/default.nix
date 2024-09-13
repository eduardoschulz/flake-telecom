{ stdenv
, gcc12Stdenv
, lib
, cmake
, fetchFromGitHub
, pkg-config
, fftwFloat
, mbedtls
, boost
, lksctp-tools
, libconfig
, pcsclite
, uhd
, soapysdr-with-plugins
, libbladeRF
, zeromq
, yaml-cpp
, libbfd
, libdwg
, libdwarf
, doxygen
}:

let
  # Define the dependency first
  dependency = stdenv.mkDerivation {


	googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-1.12.1";  # Ensure version and sha256 are correct
    sha256 = "1cv55x3amwrvfan9pr8dfnicwr8r6ar3yf6cg9v6nykd6m2v3qsv";
  	};
	};
main = gcc12Stdenv.mkDerivation rec {
  pname = "srsRAN-Project";
  version = "24_04";

  src = fetchFromGitHub {
    owner = "srsran";
    repo = "srsRAN_Project";
    rev = "release_${version}";
    hash = "sha256-ZgOeWpmcqQE7BYgiaVysnRkcJxD4fTCfKSQC5hIGTfk=";
  };


  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fftwFloat
    mbedtls
    boost
    libconfig
    lksctp-tools
    pcsclite
    uhd
    soapysdr-with-plugins
    libbladeRF
    zeromq
    yaml-cpp
    libbfd
    libdwg
    libdwarf
    doxygen
    googletest
  ];

  
  cmakeFlags = [ 
		"-Wno-dev"
		"-DGTEST_LIBRARY=${googletest}/lib"
    "-DGTEST_MAIN_LIBRARY=${googletest}/lib"
    "-DGTEST_INCLUDE_DIR=${googletest}/include"
	];
	
	buildPhase = ''
	'';
	installPhase = ''
		cd $googletest/googletest
		mkdir -p build
		cd build 
		cmake ..
	'';

  meta = {
    description = "Open source O-RAN 5G CU/DU solution from Software Radio Systems (SRS)";
    homepage = "https://github.com/srsran/srsRAN_Project";
    changelog = "https://github.com/srsran/srsRAN_Project/blob/${version}/CHANGELOG";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [];
    platforms = lib.platforms.all;
  };
};
}

