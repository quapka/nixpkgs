{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, aocl-utils
, p7zip
, which
, doxygen
}:
stdenv.mkDerivation rec {
  pname = "aocl-crypto";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "aocl-crypto";
    rev = version;
    hash = "sha256-CUUoKQ72sNFkqhaM35z94i8iuLf3FTr7caOOKXRx374=";
  };

  nativeBuildInputs = [ cmake openssl aocl-utils p7zip which doxygen ];

  cmakeFlags = [
    ("-DOPENSSL_INSTALL_DIR=" + lib.makeLibraryPath [ openssl ] + "/..")
    ("-DAOCL_UTILS_INSTALL_DIR=" + lib.makeLibraryPath [ aocl-utils ] + "/..")
    "-DENABLE_AOCL_UTILS=ON"
    "-DALCP_ENABLE_EXAMPLES=OFF"
  ];

  doCheck = false;

  patchPhase = lib.concatLines [
    # NOTE: /bin/bash is not available in NixOS
    ''
    substituteInPlace lib/CMakeLists.txt \
      --replace-fail /bin/bash bash
    ''
  ];

  installPhase = ''
    mkdir --parents $dev $out/lib

    mv libalcp.a libalcp.so libalcp_static.a  $out/lib
    mv ../include $dev
  '';

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Cryptographic library tuned for AMD Zen™ based microarchitecture";
    homepage    = "https://github.com/amd/aocl-crypto/tree/main?tab=readme-ov-file";
    maintainers = [ maintainers.quapka ];
    license = with licenses; [ bsd3 ];
  };
}
