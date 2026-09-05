# SysCare — Omarchy plugin

Omarchy Quattro bar widget for **[SysCare](https://github.com/cytracon/syscare)** `0.3.0`.

This listing is a **Quickshell bar plugin**. It does **not** ship the GTK SysCare app. Left-click opens a panel with CPU, memory, disk, and pending updates; right-click launches SysCare when `~/.local/bin/syscare` is present.

Layout follows the official Omarchy plugin template: `manifest.json`, `BarWidget.qml`, `Panel.qml`, `Model.js`.

## Install

```sh
omarchy plugin add https://github.com/cytracon/omarchy-syscare.git --enable
```

The widget lands in the right bar section. Move it in Omarchy bar settings:

```sh
omarchy bar move io.github.cytracon.syscare --section right
```

## Usage

Click the **SC** button to open or close the details panel. Press Escape to close it. Right-click launches SysCare. In the panel: **O** open, **C** safe clean, **S** source.

## Remove

```sh
omarchy plugin remove io.github.cytracon.syscare
```

Removal deletes only the plugin checkout under `~/.config/omarchy/plugins/`. It does **not** uninstall SysCare.

## Install SysCare (the app)

User-local. On Omarchy:

```bash
omarchy install syscare
```

or:

```bash
git clone https://github.com/cytracon/syscare.git
cd syscare
./install-local.sh
```

That writes `~/.local/bin/syscare` and a desktop entry. App docs: [cytracon/syscare](https://github.com/cytracon/syscare). Removing this plugin does not uninstall SysCare.

## External dependencies

- Omarchy Quattro shell (Quickshell). No extra QML modules.
- Optional: the SysCare GTK app at the fixed path `$HOME/.local/bin/syscare`.
- `omarchy-launch-browser` for the source link (ships with Omarchy).
- Safe clean runs `syscare --clean-safe` (user caches only, no root).

## Security

- No install hooks, daemons, privilege escalation, or network clients
- No writes to Hyprland / `shell.json` / pacman
- Left-click only toggles the panel
- Right-click runs the fixed path `$HOME/.local/bin/syscare` when that file exists
- “Source” opens `https://github.com/cytracon/syscare` via `omarchy-launch-browser`

Omarchy plugins run unsandboxed. Review `BarWidget.qml`, `Panel.qml`, and `Model.js` before enabling.

## License

MIT for this plugin. SysCare remains MIT.
