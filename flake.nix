{
  description = "GTK4 Wayland audio control popup for waybar";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "waybar-audio-control";
          version = "0.1.0";

          src = ./.;

          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          nativeBuildInputs = with pkgs; [
            pkg-config
            wrapGAppsHook4
          ];

          buildInputs = with pkgs; [
            gtk4
            gtk4-layer-shell
            libpulseaudio
            glib
            gdk-pixbuf
          ];

          meta = with pkgs.lib; {
            description = "GTK4 Wayland audio control popup for waybar";
            homepage = "https://github.com/rtome85/waybar-audio-control";
            license = licenses.mit;
            mainProgram = "audio-control";
            platforms = platforms.linux;
          };
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cargo
            rustc
            pkg-config
          ];

          buildInputs = with pkgs; [
            gtk4
            gtk4-layer-shell
            libpulseaudio
            glib
            gdk-pixbuf
          ];
        };
      }
    );
}
