{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "homr";
  version = "0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "liebharc";
    repo = "homr";
    rev = "ad315dc25cfce6474cc573aa13e1ba6d76d9fc7f";
    hash = "sha256-O6KBF3c04yupbpKCwlXbxJMwNY+TiYnzklsrUPhxy3I=";
  };
  pythonRelaxDepsHook = true;

  /*
    Downloading segnet_155-1240eedca553155b3c75fc9c7f643465383430a0
    Traceback (most recent call last):
      File "/nix/store/aa31bvskwcvpcypa4c482xbhf3qr1vv1-homr-0/bin/.homr-wrapped", line 9, in <module>
        sys.exit(main())
                 ~~~~^^
      File "/nix/store/aa31bvskwcvpcypa4c482xbhf3qr1vv1-homr-0/lib/python3.13/site-packages/homr/main.py", line 388, in main
        download_weights(use_gpu_inference)
        ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^
      File "/nix/store/aa31bvskwcvpcypa4c482xbhf3qr1vv1-homr-0/lib/python3.13/site-packages/homr/main.py", line 321, in download_weights
        download_utils.download_file(download_url, downloaded_zip)
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      File "/nix/store/aa31bvskwcvpcypa4c482xbhf3qr1vv1-homr-0/lib/python3.13/site-packages/homr/download_utils.py", line 19, in download_file
        with open(filename, "wb") as f:
             ~~~~^^^^^^^^^^^^^^^^
    PermissionError: [Errno 13] Permission denied: '/nix/store/aa31bvskwcvpcypa4c482xbhf3qr1vv1-homr-0/lib/python3.13/site-packages/homr/segmentation/segnet_155-1240eedca553155b3c75fc9c7f643465383430a0.zip'
  */

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'Pillow = "^11.3.0"' 'Pillow = "^12"' \
      --replace-fail 'musicxml = "1.4"' 'musicxml = "^1"' \
      --replace-fail 'opencv-python-headless = "^4.12.0.88"' 'opencv-python-headless = "^4"'
  '';

  build-system = [
    python3.pkgs.poetry-core
    python3.pkgs.poetry-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    musicxml
    numpy
    onnxruntime
    opencv-python-headless
    pillow
    rapidocr-onnxruntime
    requests
    scikit-image
    scipy
    types-pillow
    typing-extensions
  ];

  pythonImportsCheck = [
    "homr"
  ];

  meta = {
    description = "Homr is an Optical Music Recognition (OMR) software designed to transform camera pictures of sheet music into machine-readable MusicXML format";
    homepage = "https://github.com/liebharc/homr";
    changelog = "https://github.com/liebharc/homr/blob/${src.rev}/Changelog.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "homr";
  };
}
