{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
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

  CUDA_PATH="${pkgs.cudatoolkit}";
  CUDNN_PATH="${pkgs.cudaPackages.cudnn}";
   EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
   EXTRA_CCFLAGS="-I/usr/include";
}
