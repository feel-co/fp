{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # buildInputs
  rust-jemalloc-sys,

  # nativeBuildInputs
  cmake,
  installShellFiles,
  pkg-config,

  buildPackages,
  versionCheckHook,
  python3Packages,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "uv";
<<<<<<< HEAD
  version = "0.6.2";
||||||| parent of 368ef3af63da (uv: 0.5.31 -> 0.6.0)
  version = "0.5.31";
=======
  version = "0.6.0";
>>>>>>> 368ef3af63da (uv: 0.5.31 -> 0.6.0)

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-kzmdxOS5ln9/VIyPIs1mHYGZG5R8KxJDZpX+I6ucsPg=";
||||||| parent of 368ef3af63da (uv: 0.5.31 -> 0.6.0)
    hash = "sha256-Gxn/fBXPoehLkKN1PAg31sL/eMxqQMk1+oineuAO17g=";
=======
    hash = "sha256-1D1/LY8nJI14nLghYI60a4CFmu8McUIUnxB7SeXPs1o=";
>>>>>>> 368ef3af63da (uv: 0.5.31 -> 0.6.0)
  };

  useFetchCargoVendor = true;
<<<<<<< HEAD
  cargoHash = "sha256-XoXksl5N8tyJWE/J3N6fFuIrmGaehnmFEKGrMvfzdq0=";
||||||| parent of 368ef3af63da (uv: 0.5.31 -> 0.6.0)
  cargoHash = "sha256-dop61TB9w2r+our4DiKzPvw9lI07cx9bT0Ujtvhko1E=";
=======
  cargoHash = "sha256-2XLkMk6IsWho/BlPr+uxfuliAsTDat+nY0h/MJN8sXU=";
>>>>>>> 368ef3af63da (uv: 0.5.31 -> 0.6.0)

  buildInputs = [
    rust-jemalloc-sys
  ];

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package"
    "uv"
  ];

  # Tests require python3
  doCheck = false;

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd uv \
        --bash <(${emulator} $out/bin/uv generate-shell-completion bash) \
        --fish <(${emulator} $out/bin/uv generate-shell-completion fish) \
        --zsh <(${emulator} $out/bin/uv generate-shell-completion zsh)
    ''
  );

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    tests.uv-python = python3Packages.uv;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extremely fast Python package installer and resolver, written in Rust";
    homepage = "https://github.com/astral-sh/uv";
    changelog = "https://github.com/astral-sh/uv/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "uv";
  };
}
