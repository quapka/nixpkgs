{
  lib,
  buildPythonPackage,
  fetchurl,
  requests,
  lxml,
  six,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "generateds";
  version = "2.44.1";
  format = "setuptools";

  src = fetchurl {
    url = "mirror://sourceforge/generateds/${pname}-${version}.tar.gz";
    hash = "sha256-sM5VBDBxSx1DuajGjc/OCu+kZWvC4ch1YT4Jh7plJQs=";
  };

  pytestIni = ./pytest.ini;

  postUnpack = ''
    cp ${pytestIni} $sourceRoot/pytest.ini
  '';

  nativeBuildInputs = [
    lxml
  ];

  propagatedBuildInputs = [
    requests
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "online"
  ];

  patches = [
    ./port-parts-with-2to3.patch
    ./mark-online-tests.patch
  ];

  doCheck = true;

  postInstall = ''
    mkdir --parents $bin $lib
    cp $out/bin/* $bin/
  '';

  outputs = [ "out" "bin" ];

  meta = with lib; {
    description = "Generates Python data structures from an Xschema document";
    mainProgram = "generateDS";
    homepage = "https://sourceforge.net/projects/generateds/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
