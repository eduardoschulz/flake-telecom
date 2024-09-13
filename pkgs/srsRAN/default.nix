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
, gtest
, yaml-cpp
, libbfd
, libdwg
, libdwarf
, doxygen
, gcc10
}:

#(overrideCC stdenv gcc10).mkDerivation rec{
#stdenvNoCC.mkDerivation rec {
let 
	pkgs = import <nixpkgs> {};
in

gcc12Stdenv.mkDerivation rec {
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
  (pkgs.fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-1.12.1";  # Specify the version you need
    sha256 = "1cv55x3amwrvfan9pr8dfnicwr8r6ar3yf6cg9v6nykd6m2v3qsv";  # Replace with actual sha256
  })
  yaml-cpp
  libbfd
  libdwg
  libdwarf
  doxygen
  gcc10
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
