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
    udev_reload

    if use backlight_group; then
        elog "Udev rules installed. Members of the 'video' group can now"
        elog "adjust brightness without sudo."
        elog "Ensure your user is in the group: gpasswd -a <user> video"
    else
        elog "Installation complete. No udev rules were installed."
        elog "You will need root privileges (sudo) to adjust brightness."
        elog "To enable group-based control, pull the 'backlight_group' USE flag."
    fi
}

pkg_postrm() {
    udev_reload
}
