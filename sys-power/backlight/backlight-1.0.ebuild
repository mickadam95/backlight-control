EAPI=8

inherit udev

DESCRIPTION="Lightweight backlight control script with optional video group udev rules"
HOMEPAGE="https://github.com/mickadam95/backlight-control"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="backlight_group"

S="${WORKDIR}"

src_install() {
    # Always install the script
    dobin "${FILESDIR}/backlight.sh"

    # Only install the udev rule if the user wants group permissions
    if use backlight_group; then
        udev_dorules "${FILESDIR}/90-backlight.rules"
    fi
}

pkg_postinst() {
    # This reloads the rules into memory
    udev_reload

    if use backlight_group; then
        # This is the "Magic" part that was missing:
        # It forces the kernel to apply the rules to the existing backlight device
        ebegin "Updating backlight permissions"
        udevadm trigger --action=add --subsystem-match=backlight
        eend $?

        elog "Udev rules installed and triggered. Members of the 'video' group"
        elog "can now adjust brightness without sudo."
        elog "Ensure your user is in the group: gpasswd -a <user> video"
    else
        elog "Installation complete. No udev rules were installed."
        elog "To enable group-based control, set USE='backlight_group'."
    fi
}

pkg_postrm() {
    udev_reload
}
