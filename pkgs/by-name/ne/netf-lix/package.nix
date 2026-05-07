{
  lixPackageSets,
  fetchFromGitHub,
  lib,
  stdenv,
}:
let
  _ver = "2.95";
  _longVer = "${_ver}.4";
in

lixPackageSets."lix_${lib.replaceString "." "_" _ver}".lix.overrideAttrs {
  pname = "netf-lix";
  version = _longVer;

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "netflix";
    tag = "${_longVer}-netflix";
    hash = "sha256-6SMCO9JbGLzf0M2I+inTdl8zAUNi1wlecuL4MBKvxuk=";
  };

  doInstallCheck = false;
}
