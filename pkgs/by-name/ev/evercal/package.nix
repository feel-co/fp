{
  yq,
  runCommand,
  lib,
  fetchFromGitHub,
  flutter,
  nix-update-script,
}:

flutter.buildFlutterApplication rec {
  pname = "evercal";
  version = "3-unstable-2026-04-06";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "snes19xx";
    repo = "EverCal";
    rev = "faecbf55d9e652333411beeb66ea176e887b9077";
    hash = "sha256-gXbv6Vq954TBKAnzygzfNBfuFuRqWdX/jDa+PJOjG1s=";
  };

  passthru.updateScript = nix-update-script { };

  pubspecLock = lib.importJSON (
    runCommand "yaml-to-json" { } ''
      ${lib.getExe yq} -c . ${src}/pubspec.lock > $out
    ''
  );

  meta = {
    description = "Linux Calendar App that looks good";
    homepage = "https://github.com/snes19xx/EverCal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "evercal";
    platforms = lib.platforms.all;
  };
}
