{
  lib,
  buildPythonPackage,
  poetry-core,
  verysimpletree,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "musicxml";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexgorji";
    repo = "musicxml";
    rev = "v${version}";
    hash = "sha256-iTZMXR0eqZ9tsU7KZfsuJ3TUEaVFZx3UcRvKQcOq8g4=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    verysimpletree
  ];

  pythonImportsCheck = [
    "musicxml"
  ];

  meta = {
    description = "";
    homepage = "https://github.com/alexgorji/musicxml";
    changelog = "https://github.com/alexgorji/musicxml/blob/${src.rev}/ChangeLog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "musicxml";
  };
}
