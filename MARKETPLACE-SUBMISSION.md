# Marketplace submission

Submit at:
https://github.com/omacom/omarchy-plugin-marketplace/issues/new?template=submit-plugin.yml

Title:

```
[Plugin]: SysCare
```

Body (keep headings and checklist exactly):

```
### Repository URL

https://github.com/cytracon/omarchy-syscare

### Category

System

### Tags

bar, system, security

### Suggest a missing tag

cleaner

### Maintainer notes

What it is: SysCare is the Omarchy system optimizer (Stacer-style cleaner, updates, processes, security). This plugin shows a live snapshot, opens the GTK app, and installs SysCare with `omarchy install syscare` if it is missing.

Plugin ID: `io.github.cytracon.syscare`.

This is an Omarchy Quattro bar-widget (Quickshell) for SysCare 0.3.2 on Omarchy/Arch. It does not ship the GTK app. `omarchy plugin add` only clones this repo. If SysCare is missing, the panel runs `omarchy install syscare` (user-local `~/.local`).

The panel reads `$HOME/.local/bin/syscare --status` and `--check-updates`, can launch that same fixed path, and can run `--clean-safe` (user caches, no root). Source opens https://github.com/cytracon/syscare via `omarchy-launch-browser`. No Hyprland or pacman writes. MIT license. `omarchy plugin validate` passed locally.

Layout matches the official Omarchy plugin template: `BarWidget.qml` + `Panel.qml` + `Model.js`.

### Submission checklist

- [x] The repository is public and contains installation and removal instructions.
- [x] I have documented the plugin license and any external dependencies.
- [x] I confirm that I own or have permission to submit this plugin and its preview assets.
- [x] The plugin does not overwrite user configuration without explicit consent.
- [x] I understand that approval is for listing and is not a security review.
```
