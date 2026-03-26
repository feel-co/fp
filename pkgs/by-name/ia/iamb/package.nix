{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iamb";
  version = "0.0.11-unstable-2026-01-20";

  src = fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    rev = "93fc47d019cd6a9d56f163aa6ba819ef1fd309d6";
    hash = "sha256-nvEOtV1Y5K9E1Lj+bPnQ6k1AneDM9OT3RbV3Urm/1Qs=";
  };

  patches = [
    ./0001-increase-recursion-limit-to-fix-matrix-sdk-sqlite.patch
  ];

  cargoHash = "sha256-uWYNFNoCiqw6gYuHZWmZmZVs7lKNvhzjwEyxgcbvv+8=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage $src/docs/iamb.{1,5}
    install -D $src/docs/iamb.svg -t $out/share/icons/hicolor/scalable/apps
    install -D $src/docs/iamb.metainfo.xml $out/share/appdata/chat.iamb.iamb.appdata.xml
    install -D $src/iamb.desktop -t $out/share/applications
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Matrix client for Vim addicts";
    mainProgram = "iamb";
    homepage = "https://github.com/ulyssa/iamb";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meain ];
  };
})
