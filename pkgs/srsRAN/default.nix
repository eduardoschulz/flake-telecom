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
, yaml-cpp
, libbfd
, libdwg
, libdwarf
, doxygen
, python3
}:

let
  # Define googletest as a separate derivation
  googletest = stdenv.mkDerivation {
    pname = "googletest";
    version = "1.12.1";

    src = fetchFromGitHub {
      owner = "google";
      repo = "googletest";
      rev = "release-1.12.1";
      sha256 = "1cv55x3amwrvfan9pr8dfnicwr8r6ar3yf6cg9v6nykd6m2v3qsv";
    };

    nativeBuildInputs = [ cmake python3];

    buildPhase = ''
      cmake ..
      make
			ls
    '';

    installPhase = ''
			make install
    '';

      #mkdir -p $out/lib $out/include
      #cp -r lib/ $out/lib

    meta = {
      description = "Google's C++ test framework";
      homepage = "https://github.com/google/googletest";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.all;
    };
  };

  # Define the main project derivation
  main = stdenv.mkDerivation rec {
    pname = "srsRAN-Project";
    version = "24_04";

    src = fetchFromGitHub {
      owner = "srsran";
      repo = "srsRAN_Project";
      rev = "release_${version}";
      sha256 = "ZgOeWpmcqQE7BYgiaVysnRkcJxD4fTCfKSQC5hIGTfk=";
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
      googletest  # Now we are using googletest as a dependency
    ];
		configurePhase = ''
			mkdir -p build
			cd build 
			cmake .. -Wno-dev -Wfatal-errors -DBUILD_TESTS=OFF
		'';

    buildPhase = ''
      make -j20
    '';

#    installPhase = ''
#			cp -r $src/build $out
#    '';

    cmakeFlags = [
      "-Wno-dev"
			"-Wfatal-errors"
     # "-DGTEST_LIBRARY=${googletest}/lib/libgtest.a"
     # "-DGTEST_MAIN_LIBRARY=${googletest}/lib/libgtest_main.a"
     # "-DGTEST_INCLUDE_DIR=${googletest}/include"
    ];




    meta = {
      description = "Open source O-RAN 5G CU/DU solution from Software Radio Systems (SRS)";
      homepage = "https://github.com/srsran/srsRAN_Project";
      changelog = "https://github.com/srsran/srsRAN_Project/blob/${version}/CHANGELOG";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [];
      platforms = lib.platforms.all;
    };
  };
in
  main

