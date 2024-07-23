{ lib
, stdenv
, fetchgit
, cmake
, pkg-config
, jdk17_headless
, wolfssl
, ant
}:
# let
#   wolfsslx = wolfssl.override { extraConfigureFlags = ["--enable-jni"]; };
# in
stdenv.mkDerivation rec {
  pname = "wolfcrypt-jni";
  version = "1.6.0";

  src = fetchgit {
    url = "https://github.com/wolfSSL/wolfcrypt-jni";
    rev = "v${version}-stable";
    hash = "sha256-oVhbReWV9W/j/7n2JuXoT62/ramRVkqB+Ax4+Btn3HI=";
  };

  nativeBuildInputs = [ cmake ant wolfssl pkg-config jdk17_headless ];


  configurePhase = ''
    cp makefile.linux makefile
  '';

  buildPhase = ''
    make
    ant build-jce-release
  '';

  # NOTE: put .build/RELEASE/pkgconfig to $out/lib/?
  installPhase = ''
    mkdir --parents $out/lib
    mv lib/wolfcrypt-jni.jar $out/lib
    mv lib/wolfcryptjni.so $out/lib
  '';

  # FIXME we want JUNIT_HOME set for testing, but we don't have JUnit package now
  JUNIT_HOME="";

  # doCheck = true;
  # checkPhase = ''
  #   ant test
  # '';

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "wolfCrypt JCE provider and JNI wrapper";
    homepage    = "https://github.com/wolfSSL/wolfcrypt-jni";
    maintainers = [ maintainers.quapka ];
    license = licenses.gpl2;
  };
}
