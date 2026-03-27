Gentoo Backlight Control (OpenRC-Friendly)

A lightweight, system-wide backlight control solution for Linux, designed specifically for Gentoo systems using OpenRC or systems where a minimal footprint is desired.

## Key Improvements
* **No Systemd Required**: Directly interfaces with the kernel via `/sys/class/backlight`.
* **Sandbox Safe**: Fully complies with Gentoo's `src_install` and QA requirements.
* **Automated Permissions**: Uses high-priority `udev` rules (`99-backlight.rules`) to handle hardware permissions at runtime.
* **Zero-Config Triggering**: The ebuild automatically reloads and triggers `udev` upon installation.

## Features
* **Lightweight**: Minimalist Bash script with no heavy dependencies.
* **Secure**: Uses the standard `video` group (optional) to allow brightness adjustment without `sudo`.
* **Universal**: Works with Intel, AMD, and ACPI video drivers.
* **DE-Agnostic**: Compatible with LXQt, XFCE, i3, Sway, and more.

---

## Installation

### 1. Add the Overlay
The recommended way to add this custom Gentoo overlay is via `eselect repository`.

# Install eselect-repository if you haven't already
emerge --ask app-eselect/eselect-repository

# Add and sync the repo
eselect repository add backlight-control git [https://github.com/mickadam95/backlight-control.git](https://github.com/mickadam95/backlight-control.git)

emerge --sync backlight-control


### 2. Configure USE Flags

Decide if you want the dedicated group management. Add this to /etc/portage/package.use/backlight:

sys-power/backlight backlight_group

### 3. Emerge

emerge --ask sys-power/backlight

---

Configuration & Permissions

If you enabled the backlight_group USE flag:

    Add your user to the video group
    

gpasswd -a $USER video


Keybinding Setup

Bind your hardware keys (typically XF86MonBrightnessUp and XF86MonBrightnessDown) to the following commands:
Action	Command
Brightness Up	/usr/bin/backlight.sh up
Brightness Down	/usr/bin/backlight.sh down

---

Troubleshooting
No backlight detected

If /sys/class/backlight/ is empty, ensure your kernel is configured with:

    Device Drivers -> Graphics support -> Backlight & LCD device support

    The specific driver for your GPU (e.g., CONFIG_DRM_I915 or CONFIG_DRM_AMDGPU).

Permission Denied

Check the permissions on the hardware file:
Bash

ls -l /sys/class/backlight/*/brightness

If you don't see rw permissions for the video group (e.g., -rw-rw-r-- 1 root video), ensure the backlight_group USE flag was enabled during installation.

---

Why this exists

Many existing tools like xbacklight are deprecated or rely on X11-specific features. While brightnessctl is a great alternative, this project provides a native Gentoo experience that leverages the existing video group and udev system without extra binary overhead.
