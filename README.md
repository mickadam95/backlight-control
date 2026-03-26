# Gentoo Backlight Control (OpenRC-Friendly)

A lightweight, system-wide backlight control solution for Linux, designed for OpenRC systems.

This package installs:
- A universal backlight control script (`/usr/local/bin/backlight.sh`)
- A udev rule to allow non-root brightness control
- Optional `backlight` group for safe permission handling

Supports:
- Intel (`intel_backlight`)
- AMD (`amdgpu_bl0`, `radeon_bl0`)
- ACPI (`acpi_video0`)

---

## Features

- No systemd required
- Works with LXQt, XFCE, i3, etc.
- FN key compatible (via manual keybinding)
- Secure group-based permission model (optional)
- Automatically detects your backlight device

---

## Installation (Gentoo Overlay)

1. Add this repository as an overlay (example):


2. Install the package:
emerge --ask sys-power/backlight

---

## USE Flags

| USE Flag           | Description |
|------------------|------------|
| `backlight_group` | Creates a `backlight` group and allows non-root brightness control |

Example:
emerge --ask sys-power/backlight backlight_group


---

## Permissions Setup

If using the `backlight_group` USE flag:

1. Add your user to the group:
gpasswd -a $USER backlight



2. Log out and back in

---

## Keybinding Setup (LXQt Example)

1. Open:
   Preferences → Shortcut Keys

2. Add bindings:

| Action           | Command                          |
|------------------|----------------------------------|
| Brightness Up    | `/usr/local/bin/backlight.sh up` |
| Brightness Down  | `/usr/local/bin/backlight.sh down` |

Your keys will typically be:
- `XF86MonBrightnessUp`
- `XF86MonBrightnessDown`

---

## Usage

Manual control:
backlight.sh up
backlight.sh down

---

## Troubleshooting

### No backlight detected
Check:
ls /sys/class/backlight/

If empty:
- Ensure kernel backlight drivers are enabled
- Check GPU drivers (Intel/AMD)

---

### Permission denied

Check:
ls -l /sys/class/backlight/*/brightness

Expected (if using backlight group):
-rw-rw-r-- root backlight ...


If not:
- Ensure udev rule is installed
- Reload rules:
udevadm control --reload-rules
udevadm trigger

---

### FN keys not working

- Verify key events:
- Bind keys manually in your DE

---

## Notes

- `xbacklight` is not used because it does not work with modern `intel_backlight` setups
- This tool directly interfaces with `/sys/class/backlight` for maximum compatibility

---

## License

MIT License

---

## Contributing

Pull requests are welcome. Potential improvements:

- Notifications (`notify-send`)
- Multi-device selection
- Wayland support enhancements

---

## Why this exists

I wanted a simple light-weight backlight handler and xbacklight would not work. I know brightnessctl exists but can have some interaction with systemd-logind and didnt want to mess with it.

---

