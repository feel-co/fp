{
  haskell,
  haskellPackages,
  installShellFiles,
  lib,
  extraComposeFunctions ? [ ],
}:
let
  inherit (lib.lists) zipListsWith;
  inherit (lib.strings) concatLines escapeShellArg;
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;

  overrides = {
    passthru.updateScript = ./update.sh;

    # nom has unit-tests and golden-tests
    # golden-tests call nix and thus can’t be run in a nix build.
    testTargets = [
      "unit-tests"
      "doc-tests"
    ];

    buildTools = [ installShellFiles ];

    postPatch =
      let
        oldIcons = [
          "↑"
          "↓"
          "⏱"
          "⏵"
          "✔"
          "⏸"
          "⚠"
          "∅"
          "∑"
        ];
        newIcons = [
          "f062" # 
          "f063" # 
          "f520" # 
          "f04b" # 
          "f00c" # 
          "f04c" # 
          "f071" # 
          "f1da" # 
          "f04a0" # 󰒠
        ];
      in
      assert __length oldIcons == __length newIcons;
      ''
        sed -i ${
          escapeShellArg (concatLines (zipListsWith (o: n: "s/${o}/\\\\x${n}/") oldIcons newIcons))
        } lib/NOM/Print.hs
        sed -i 's/┌/╭/' lib/NOM/Print/Tree.hs
      '';

    postInstall = ''
      ln -s nom "$out/bin/nom-build"
      ln -s nom "$out/bin/nom-shell"
      chmod a+x $out/bin/nom-build
      installShellCompletion completions/*
    '';
  };
  raw-pkg = haskellPackages.callPackage ./generated-package.nix { };
in
lib.pipe raw-pkg (
  [
    (overrideCabal overrides)
    justStaticExecutables
  ]
  ++ extraComposeFunctions
)
