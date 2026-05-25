# shell.nix
{ pkgs ? import <nixpkgs> {
    config.android_sdk.accept_license = true;
    config.allowUnfree = true;
  }
}:

let
  androidSdk = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [
        "34"
        "35"
        "36"
    ];

    buildToolsVersions = [
      "28.0.3"
      "35.0.0"
      "36.0.0"
    ];

    ndkVersions = [
        "28.2.13676358"
    ];

    cmakeVersions = [
        "3.22.1"
    ];

    abiVersions = [
      "arm64-v8a"
      "armeabi-v7a"
    ];

    includeNDK = true;
    includeEmulator = false;
    includeSystemImages = false;
  };
in

pkgs.mkShell {
  packages = with pkgs; [
    flutter
    jdk21
    git
    curl
    unzip

    androidSdk.androidsdk
    android-tools

    clang
    cmake
    ninja
    pkg-config
  ];

  ANDROID_HOME =
    "${androidSdk.androidsdk}/libexec/android-sdk";

  ANDROID_SDK_ROOT =
    "${androidSdk.androidsdk}/libexec/android-sdk";

  ANDROID_NDK_ROOT =
    "${androidSdk.androidsdk}/libexec/android-sdk/ndk/28.2.13676358";

  JAVA_HOME = pkgs.jdk21.home;

  shellHook = ''
    export PATH="$ANDROID_SDK_ROOT/platform-tools:$PATH"
    export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"

    echo "Flutter Android environment ready"
  '';
}