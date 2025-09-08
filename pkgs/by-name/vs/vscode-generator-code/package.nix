{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "vscode-generator-code";
  version = "1.11.12";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-generator-code";
    tag = "v${version}";
    hash = "sha256-Ci3Jb6cseqN2nYskzpKx5fwoEcNaZEehZG7JKTbmSb0=";
  };

  npmDepsHash = "sha256-d3OlkPCfNY2KXaYcErn56rm+wK/Dz8oWEKmwGvo3UII=";
  dontNpmBuild = true;

  postInstall = ''
    cp -r generators $out/
  '';

  meta = {
    description = "Visual Studio Code extension generator";
    homepage = "https://github.com/microsoft/vscode-generator-code";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "vscode-generator-code";
    platforms = lib.platforms.all;
  };
}
