{ stdenv
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
, gtest
, yaml-cpp
, libbfd
, libdwg
, libdwarf
, doxygen
}:

stdenv.mkDerivation rec {
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
		gtest
		yaml-cpp
		libbfd
		libdwg
		libdwarf
		doxygen
  ];
	#"-DENABLE_WERROR=OFF" "-DENABLE_ZEROMQ=TRUE" "-DENABLE_EXPORT=TRUE"

	cmakeFlags = [ "-DBUILD_TESTING=OFF"  ];

  meta = {
    description = "Open source O-RAN 5G CU/DU solution from Software Radio Systems (SRS) https://docs.srsran.com/projects/project";
    homepage = "https://github.com/srsran/srsRAN_Project";
    changelog = "https://github.com/srsran/srsRAN_Project/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "srsRAN-Project";
    platforms = lib.platforms.all;
  };
}
