# waybar-audio-control

A GTK4 Wayland audio control popup for [waybar](https://github.com/Alexays/Waybar), built with [gtk4-layer-shell](https://github.com/wmww/gtk4-layer-shell) and [libpulse](https://www.freedesktop.org/wiki/Software/PulseAudio/).

Displays a popup with per-application volume sliders, playback device selection, and input device selection. Positioning and colors are fully configurable. Dismisses when clicking outside the popup.

## Features

- **Per-application volume control** — streams are grouped by application name so each app gets one slider regardless of how many PulseAudio sink inputs it opens
- **Playback device selection** — lists all sinks, marks the current default, click to switch
- **Input device selection** — lists all sources (monitors excluded), marks the current default, click to switch
- **Persistent background process** — the process stays alive and `SIGUSR1` toggles the window, so subsequent clicks are instant
- **Configurable theme and position** — user-defined colors and window anchoring via `~/.config/waybar-audio-control/config.toml`
- **Four corner positioning** — anchor to top-left, top-right, bottom-left, or bottom-right with custom margins
- **Dismisses on click outside** the popup
- **Auto-refreshes** audio state every 2 seconds

## Requirements

- Wayland compositor with [wlr-layer-shell](https://wayland.app/protocols/wlr-layer-shell-unstable-v1) support (Hyprland, Sway, etc.)
- PulseAudio or PipeWire with PulseAudio compatibility layer
- GTK4
- gtk4-layer-shell
- A [Nerd Font](https://www.nerdfonts.com/) for application icons and media control glyphs

## Building

```bash
cargo build --release
```

The binary will be at `target/release/audio-control`.

## Waybar Integration

The process persists in the background after first launch and uses a PID file at `/tmp/audio-control.pid` for IPC. Subsequent waybar clicks send `SIGUSR1` to the running process to toggle visibility instead of spawning a new instance.

Add a custom module to your waybar config (`~/.config/waybar/config`):

```json
"custom/audio": {
    "format": "󰕾",
    "on-click": "/path/to/audio-control",
    "tooltip": false
}
```

Add it to your bar's modules:

```json
"modules-right": ["custom/audio", "clock", ...]
```

## Configuration

Create `~/.config/waybar-audio-control/config.toml` to customize colors and window position. All settings are optional; defaults are provided.

```toml
[colors]
foreground = "#cdd6f4"    # Text color
background = "#1e1e2e"    # Background color
accent = "#f5c2e7"        # Highlight/accent color

[position]
anchor = "top-right"      # Corner: "top-left", "top-right", "bottom-left", "bottom-right"
margin_top = 10
margin_right = 10
margin_bottom = 10
margin_left = 10
```

**Defaults:** Catppuccin Mocha theme, positioned at top-right with 10px margins.

## Dependencies

| Crate | Version | Purpose |
|---|---|---|
| `gtk4` | 0.9 | UI framework |
| `gtk4-layer-shell` | 0.4 | Wayland layer shell integration |
| `gdk4` | 0.9 | GDK bindings |
| `glib` | 0.20 | GLib utilities |
| `libpulse-binding` | 2.28 | PulseAudio interface |
| `libc` | 0.2 | POSIX signal handling |
| `serde` | 1.0 | Serialization framework |
| `toml` | 1.1 | TOML parsing |

## Architecture

```
main.rs   — Entry point; PID file IPC; SIGUSR1 toggle; backdrop + popup window setup
ui.rs     — GTK4 UI layout, layer shell config, CSS theming, all section renderers
audio.rs  — PulseAudio interface (sink inputs, sinks, sources, volume control)
config.rs — Configuration loading (TOML parsing, defaults, validation)
```

**Dismissal mechanism:** A fullscreen transparent backdrop window sits at `Layer::Top`. The popup itself is at `Layer::Overlay` (above everything). Clicking outside the popup hits the backdrop, which hides both windows. `Alt+F4` / compositor close requests are intercepted and treated as hide instead of quit.

**Grouping:** Multiple PulseAudio sink inputs from the same application (e.g. a browser with several audio tabs) are collapsed into a single volume slider. Moving the slider sets volume on all of that app's underlying sink inputs simultaneously.

## License

MIT
