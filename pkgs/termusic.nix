{
  alsa-lib,
  AppKit,
  CoreAudio,
  CoreGraphics,
  dbus,
  Foundation,
  fetchFromGitHub,
  glib,
  gst_all_1,
  IOKit,
  lib,
  MediaPlayer,
  openssl,
  pkg-config,
  protobuf,
  rustPlatform,
  Security,
  sqlite,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "elias-ainsworth";
    repo = "termusic";
    rev = "391f3f193eb43e5594d9cbe89d515fd980f96feb";
    hash = "sha256-I97gk7KXH6s1pbVFOVZGh3j7cb5HjRIn63WDt45ztQA=";
  };

  postPatch = ''
    pushd $cargoDepsCopy/stream-download
    oldHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
    substituteInPlace $cargoDepsCopy/stream-download/src/lib.rs \
      --replace-warn '#![doc = include_str!("../README.md")]' ""
    substituteInPlace .cargo-checksum.json \
      --replace $oldHash $(sha256sum src/lib.rs | cut -d " " -f 1)
    popd
  '';

  cargoHash = "sha256-r5FOl3Bp3GYhOhvWj/y6FXsuG2wvuFcMcYKBzVBVqiM=";

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      dbus
      glib
      gst_all_1.gstreamer
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.isDarwin [
      AppKit
      CoreAudio
      CoreGraphics
      Foundation
      IOKit
      MediaPlayer
      Security
    ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
    ];

  meta = {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/elias-ainsworth/termusic";
    license = with lib.licenses; [gpl3Only];
    maintainers = with lib.maintainers; [elias-ainsworth];
    mainProgram = "termusic";
  };
}
