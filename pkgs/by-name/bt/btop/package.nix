{
  lib,
  config,
  stdenv,
  fetchpatch2,
  fetchFromGitHub,
  cmake,
  removeReferencesTo,
  autoAddDriverRunpath,
  apple-sdk_15,
  versionCheckHook,
  nix-update-script,
  rocmPackages,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "btop";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = "btop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3gECGBSWcGTYQkUlD4X2zrxZVvH2x2xfh5zdZ2jJbDQ=";
  };

  patches = [
    (fetchpatch2 {
      name = "themes-load-save-by-name-if-possible.patch";
      url = "https://github.com/aristocratos/btop/pull/1390/commits/30b3868787b7f6c1b83a0e790a5e6ee6c28de28c.patch";
      hash = "sha256-ql/KUwbTU+uChIIlEjJOEArHRauuw996kuXXAcEptDM=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  installFlags = [ "PREFIX=$(out)" ];

  # fix build on darwin (see https://github.com/NixOS/nixpkgs/pull/422218#issuecomment-3039181870 and https://github.com/aristocratos/btop/pull/1173)
  cmakeFlags = [
    (lib.cmakeBool "BTOP_LTO" (!stdenv.hostPlatform.isDarwin))
    (lib.cmakeBool "BTOP_STATIC" (stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BTOP_FORTIFY" (!stdenv.hostPlatform.isStatic))
  ];

  hardeningDisable = lib.optionals stdenv.hostPlatform.isStatic [ "fortify" ];

  postInstall = ''
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/bin/btop)
  '';

  postPhases = lib.optionals rocmSupport [ "postPatchelf" ];
  postPatchelf = lib.optionalString rocmSupport ''
    patchelf --add-rpath ${lib.getLib rocmPackages.rocm-smi}/lib $out/bin/btop
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Monitor of resources";
    homepage = "https://github.com/aristocratos/btop";
    changelog = "https://github.com/aristocratos/btop/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      khaneliman
      rmcgibbo
      ryan4yin
      sigmasquadron
    ];
    mainProgram = "btop";
  };
})
