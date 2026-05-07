{
  lixPackageSets,
  fetchFromGitHub,
  lib,
}:
let
  _ver = "2.94";
  _longVer = "${_ver}.2";
in

lixPackageSets."lix_${lib.replaceString "." "_" _ver}".lix.overrideAttrs {
  pname = "netf-lix";

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "netflix";
    tag = "${_longVer}-netflix";
    hash = "sha256-MqX1p7rEzPLau/guUvTYpjEoly++Eo1r1lOnEdd72yM=";
  };
}
