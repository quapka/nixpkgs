{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # package deps
  lxml,
  dict2xml,
  xmltodict,
  six,
  aenum,
  tblib,
  requests,
  # dev deps
  check-manifest,
  # test deps
  coverage,
  pytest,
  tox
}:

buildPythonPackage rec {
  pname = "pyone";
  version = "6.9.80";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OpenNebula";
    repo = "one";
    rev = "refs/tags/release-${version}";
    hash = "sha256-iJEWhZpvNTMlvv2lVn5DD2Ali+andrLQg/rPCttjbII=";
  };

  sourceRoot = "source/src/oca/python";

  nativeBuildInputs = [
    lxml
    dict2xml
    xmltodict
    six
    aenum
    tblib
    requests
  ];

  doCheck = false;

  nativeCheckInputs = [
    coverage
    pytest
    tox
  ];

  meta = with lib; {
    description = "";
    mainProgram = "";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = licenses.asl20;
    maintainers = with maintainers; [ maintainers.quapka ];
  };
}
