{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "iamb";
  version = "0.0.11-alpha.1-unstable-2025-10-26";

  src = fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    rev = "a32149f60413736e797723582fca49c991b8edcd";
    hash = "sha256-8sqS7Iw1H5BB+MWjRulM+ZZECw/vbAe/ofPJs50EcH0=";
  };

  cargoHash = "sha256-Ce0sTp3f6XKqaSqOoEC+sYXX6lwLG9Fa0pZcWjY0d7w=";

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Attempted to create a NULL object.
    "--skip=base::tests::test_complete_cmdbar"
    "--skip=base::tests::test_complete_msgbar"

    # Attempted to create a NULL object.
    "--skip=windows::room::scrollback::tests::test_cursorpos"
    "--skip=windows::room::scrollback::tests::test_dirscroll"
    "--skip=windows::room::scrollback::tests::test_movement"
    "--skip=windows::room::scrollback::tests::test_search_messages"
  ];

  postInstall = ''
    installManPage $src/docs/iamb.{1,5}
    install -D $src/docs/iamb.svg -t $out/share/icons/hicolor/scalable/apps
    install -D $src/docs/iamb.metainfo.xml $out/share/appdata/chat.iamb.iamb.appdata.xml
    install -D $src/iamb.desktop -t $out/share/applications
  '';


  env.VERGEN_GIT_SHA = src.rev;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  #doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Matrix client for Vim addicts";
    mainProgram = "iamb";
    homepage = "https://github.com/ulyssa/iamb";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meain ];
  };
}
