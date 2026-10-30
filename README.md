# SysCare — Omarchy plugin

**What it is.** [SysCare](https://github.com/cytracon/omarchy-cytracon-syscare) is the Omarchy system optimizer (Stacer-style): clean caches, review updates, inspect processes and security, uninstall packages.

This plugin is the bar UI for that app: live CPU/memory/disk/updates, a user-cache-only safe clean, and a launch into SysCare. If the GTK app is missing, the panel runs `omarchy install syscare` (app + this plugin).

Layout follows the official Omarchy plugin template: `manifest.json`, `BarWidget.qml`, `Panel.qml`, `Model.js`.

## Install

One command installs the **GTK app and this plugin**:

```bash
omarchy install syscare
```

Or add the widget first, then click **Install SysCare** in the panel:

```sh
omarchy plugin add https://github.com/cytracon/omarchy-cytracon-bar-syscare.git --enable
```

```sh
omarchy bar move io.github.cytracon.syscare --section right
```

## Usage

Click **SC** to open or close the panel. Escape closes it. Right-click opens SysCare (or installs if missing). In the panel: **I** install, **O** open, **C** safe clean, **S** source.

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

That writes `~/.local/bin/syscare` and a desktop entry. App docs: [cytracon/omarchy-cytracon-syscare](https://github.com/cytracon/omarchy-cytracon-syscare). Removing this plugin does not uninstall SysCare.

## External dependencies

- Omarchy Quattro shell (Quickshell). No extra QML modules.
- SysCare at `$HOME/.local/bin/syscare` (installed by the panel or by `omarchy install syscare`).
- `omarchy-launch-floating-terminal-with-presentation` and `omarchy-launch-browser` (ship with Omarchy).
- Safe clean runs `syscare --clean-safe` (user caches only, no root).

## Security

- No writes to Hyprland / `shell.json` / pacman
- Left-click toggles the panel
- Right-click runs `$HOME/.local/bin/syscare`, or installs SysCare if missing
- Install runs `omarchy install syscare` in a floating terminal
- “Source” opens `https://github.com/cytracon/omarchy-cytracon-syscare` via `omarchy-launch-browser`

Omarchy plugins run unsandboxed. Review `BarWidget.qml`, `Panel.qml`, and `Model.js` before enabling.

## License

MIT for this plugin. SysCare remains MIT.
