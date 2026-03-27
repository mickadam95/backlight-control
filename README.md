Gentoo Backlight Control (OpenRC-Friendly)

A lightweight, system-wide backlight control solution for Linux, designed specifically for Gentoo systems using OpenRC or systems where a minimal footprint is desired.
Key Improvements

    No Systemd Required: Directly interfaces with the kernel via /sys/class/backlight.

    Sandbox Safe: Complies with Gentoo's src_install requirements.

    Dynamic Hardware Support: Uses udev to handle hardware detection at runtime rather than build time.

Features:

    Lightweight: Minimalist Bash script with no heavy dependencies.

    Secure: Uses a dedicated backlight group (optional) to avoid running scripts as root.

    Universal: Works with Intel, AMD, and ACPI video drivers.

    DE-Agnostic: Compatible with LXQt, XFCE, i3, Sway, and more.

Installation
1. Add the Overlay

The recommended way to add a custom Gentoo overlay is via repos.conf or eselect repository.
Bash

# Using eselect-repository
eselect repository add backlight-control git https://github.com/mickadam95/backlight-control.git
emaint sync -r backlight-control

2. Configure USE Flags

Decide if you want the dedicated group management. Add this to /etc/portage/package.use/backlight:
Plaintext

sys-power/backlight backlight_group

3. Emerge
Bash

emerge --ask sys-power/backlight

Configuration & Permissions

If you enabled the backlight_group USE flag:

    Add your user to the group:
    Bash

gpasswd -a $USER backlight

Reload Udev Rules:
Bash

    udevadm control --reload-rules && udevadm trigger

    Log out and back in for the group changes to take effect.

Keybinding Setup

Bind your hardware keys (typically XF86MonBrightnessUp and XF86MonBrightnessDown) to the following commands:
Action	Command
Brightness Up	/usr/bin/backlight.sh up
Brightness Down	/usr/bin/backlight.sh down

    Note: The path has been moved to /usr/bin/ to comply with Gentoo filesystem standards.

Troubleshooting
No backlight detected

If /sys/class/backlight/ is empty, ensure your kernel is configured with:

    Device Drivers -> Graphics support -> Backlight & LCD device support

    The specific driver for your GPU (e.g., CONFIG_DRM_I915 or CONFIG_DRM_AMDGPU).

Permission Denied

Check the permissions on the hardware file:
Bash

ls -l /sys/class/backlight/*/brightness

If you aren't seeing rw permissions for the backlight group, ensure the udev rule was installed to /lib/udev/rules.d/90-backlight.rules.
Why this exists

Many existing tools like xbacklight are deprecated or rely on X11-specific features that don't work with modern drivers or Wayland. While brightnessctl is a great alternative, this project provides a transparent, script-based approach that integrates deeply with Gentoo's OpenRC and group-management philosophy without extra overhead.
