{ 
  stdenv, 
  lib, 
  fetchFromGitHub, 
  qt6, 
  pkg-config, 
  libsecret, 
  libgcrypt, 
  libgpg-error, 
  wrapQtAppsHook, 
  cmake 
}:

let 
  version = "4.1.0.1";
in stdenv.mkDerivation {
  pname = "amnezia-client";
  version = version;

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amnezia-client";
    rev = version;
    sha256 = "sha256-974NyMhy8AtxvYWnsHV/yrAZdZMuFWDsswPlsbFE+6c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ 
    cmake 
    pkg-config
    wrapQtAppsHook 
  ];
  
  buildInputs = with qt6; [ 
    qtbase 
    qtremoteobjects
    qtsvg 
    qt5compat 
    qttools
    qtwayland
  ] ++ [
    libsecret 
    libgcrypt 
    libgpg-error
  ];

  configurePhase = ''
    # This line is taken from qt-cmake
    cmake -DCMAKE_TOOLCHAIN_FILE="${qt6.qtbase}/lib/cmake/Qt6/qt.toolchain.cmake" -S .
    
    cmake --build . --config release
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp client/AmneziaVPN $out/bin/AmneziaVPN
  '';
}
