{ pkgs, ... }:

{
  packages = with pkgs; [
    gtk4
    gtk4-layer-shell
    libpulseaudio
    glib
    gdk-pixbuf
    pkg-config
  ];

  languages.rust = {
    enable = true;
  };

  env = {
    PKG_CONFIG_PATH =
      with pkgs;
      lib.makeSearchPath "lib/pkgconfig" [
        gtk4.dev
        gtk4-layer-shell.dev
        libpulseaudio.dev
        glib.dev
        gdk-pixbuf.dev
        rust-analyzer
      ];
  };

  enterShell = ''
    echo "waybar-audio-control dev shell"
    echo "  cargo build --release   build the project"
    echo "  cargo run               run in dev mode"
    echo "  cargo clippy            lint"
    echo "  cargo fmt               format"
  '';
}
