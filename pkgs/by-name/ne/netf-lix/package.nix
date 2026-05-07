{
  lixPackageSets,
  fetchFromGitHub,
  lib,
  stdenv,
}:
let
  _ver = "2.95";
  _longVer = "${_ver}.3";
in

lixPackageSets."lix_${lib.replaceString "." "_" _ver}".lix.overrideAttrs {
  pname = "netf-lix";
  version = _longVer;

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "netflix";
    tag = "${_longVer}-netflix";
    hash = "sha256-nh2I6jaGl60o5tYp2UeD2NDZ7LJODlWyGwO+cccVgD4=";
  };

  doInstallCheck = false;
}
