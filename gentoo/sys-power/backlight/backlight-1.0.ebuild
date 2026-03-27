inherit udev user

DESCRIPTION="A lightweight, system-wide backlight control solution for Linux, designed specifically for Gentoo systems using OpenRC or systems where a minimal footprint is desired."
HOMEPAGE="https://github.com/mickadam95/backlight-control"
IUSE="backlight_group"

pkg_setup() {
    # If the user wants a custom group, we create it safely BEFORE installation
    # Note: Gentoo conventionally uses the 'video' group for this, but if you 
    # strictly want 'backlight', enewgroup is the safe way to do it.
    if use backlight_group; then
        enewgroup backlight
    fi
}

src_install() {
    # 1. Install to /usr/bin, NOT /usr/local/bin. 
    # (/usr/local is reserved for the system admin; Portage owns /usr).
    dobin "${FILESDIR}/backlight.sh"

    # 2. Install a GENERIC udev rule. 
    # Packages should install rules to /lib/udev/rules.d, not /etc.
    udev_dorules "${FILESDIR}/90-backlight.rules"
}

pkg_postinst() {
    # 3. Print messages in postinst, otherwise they get lost in the build log.
    elog "Installation complete."
    
    if use backlight_group; then
        elog ""
        elog "To allow your user to change brightness without sudo, add them to the group:"
        elog "  gpasswd -a <username> backlight"
        elog ""
        elog "You may need to reboot or reload udev rules for permissions to apply:"
        elog "  udevadm control --reload-rules && udevadm trigger"
    fi

    elog ""
    elog "Set keybindings manually in your Desktop Environment."
}
