{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  pname = "lc0";
  version = "master";
  
  src = pkgs.fetchgit {
    url = "https://github.com/LeelaChessZero/lc0.git";
    rev = "865df708fc4d59eb54b736a1b14edb602afa3d12";
    sha256 ="sha256-dGllpcdHAGwcG5I9qwu3dYn0mGCM3IzWgfs/Yq20fG0=";
  };

  buildInputs = with pkgs; [
    mkl
    openblas
    eigen
    oneDNN
    zlib
  ];

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    python3
        clang
    cudatoolkit
cudaPackages.libcublas
  ];
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
    cudatoolkit
    cudatoolkit.lib
    openblas
linuxPackages.nvidia_x11
cudaPackages.libcublas
    cudaPackages.cudnn
  ]);

  mesonFlags = [
    "-Dblas=true"
    "-Dopenblas_include=${pkgs.openblas}/include"
    "-Dopenblas_libdirs=${pkgs.openblas}/lib"
    "-Dmkl=true"
    "-Dmkl_include=${pkgs.mkl}/include"
    "-Dmkl_libdirs=${pkgs.mkl}/lib"
    "-Ddnnl=true"
    "-Ddnnl_dir=${pkgs.oneDNN}"
    "-Donednn=false"
    "-Dgtest=false"
    "-Dcudnn_include=${pkgs.cudatoolkit}/include,${pkgs.cudaPackages.cudnn}/include"
    "-Dcudnn_libdirs=${pkgs.cudatoolkit}/lib,${pkgs.cudaPackages.cudnn}/lib,${pkgs.cudatoolkit.lib}/lib"
  ];

  # This is called during the build process
  postPatch = ''
    patchShebangs scripts/compile_proto.py
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    mv lc0 $out/bin
  '';
}
