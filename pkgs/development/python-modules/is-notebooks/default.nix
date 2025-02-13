{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  lxml,
  beautifulsoup4
}:

buildPythonPackage rec {
  pname = "is-notebooks";
  version = "0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    inherit pname version;
    owner = "j08ny";
    repo = "is-notebooks";
    rev = "master";
    hash = "sha256-ytfG+b0sYXD5DV9Y1/oM4BKN7wiqG4dv0KOip1Lho6w=";
  };

  dependencies = [
    requests
    lxml
    beautifulsoup4
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = false;

  pythonImportsCheck = [ "is_notebooks" ];

  meta = with lib; {
    description = "Python bindings for MUNI IS notebooks API";
    homepage = "https://github.com/j08nY/is-notebooks";
    license = licenses.mit;
    maintainers = with maintainers; [ quapka ];
  };
}
