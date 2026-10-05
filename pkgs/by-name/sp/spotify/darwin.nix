{
  stdenv,
  pname,
  meta,
  fetchurl,
  undmg,
  updateScript,
  lib,
}:

stdenv.mkDerivation {
  inherit pname;

  version = "1.3.4.258";

  # WARNING: This Wayback Machine URL redirects to the closest timestamp.
  # Future maintainers must manually check the timestamp exists and exactly matches at:
  # https://web.archive.org/web/*/https://download.scdn.co/SpotifyARM64.dmg
  src = fetchurl {
    url = "https://web.archive.org/web/20261015091109/https://download.scdn.co/SpotifyARM64.dmg";
    hash = "sha256-3P7pmA7wJq/7lK8PB/H7NQDy/wMcvLmVWnmPFnhAGw8=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru = { inherit updateScript; };

  meta = meta // {
    maintainers = with lib.maintainers; [
      matteopacini
      Enzime
    ];
  };
}
