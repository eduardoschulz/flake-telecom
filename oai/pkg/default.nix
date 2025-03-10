{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
	asn1c,
	fftwFloat,
	mbedtls,
	boost,
	libconfig,
	lksctp-tools,
	pcsclite,
	uhd,
	pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "openairinterface5g";
  version = "2.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.eurecom.fr";
    owner = "oai";
    repo = "openairinterface5g";
    rev = "v${version}";
    hash = "sha256-SM2HhbAhN5IRDx4eBNJgJR7bAcDNO7EOvK5zRE0rYnE=";
    fetchSubmodules = true;
  };
	buildInputs = [
    fftwFloat
    mbedtls
    boost
    libconfig
    lksctp-tools
    pcsclite
    uhd
		asn1c
		pkg-config
  ];

  nativeBuildInputs = [
		cmake
  ];

  meta = {
    description = "Openairinterface 5G Wireless Implementation";
    homepage = "https://gitlab.eurecom.fr/oai/openairinterface5g";
    changelog = "https://gitlab.eurecom.fr/oai/openairinterface5g/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "openairinterface5g";
    platforms = lib.platforms.all;
  };
}
