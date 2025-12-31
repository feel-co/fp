{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "verysimpletree";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexgorji";
    repo = "verysimpletree";
    rev = "v${version}";
    hash = "sha256-138cEh8Pe8rCNci8mYRNOwzp27Zrjbt6V9N05b3OEJA=";
  };

  build-system = [
    poetry-core
  ];

  pythonImportsCheck = [
    "verysimpletree"
  ];

  meta = {
    description = "";
    homepage = "https://github.com/alexgorji/verysimpletree";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
