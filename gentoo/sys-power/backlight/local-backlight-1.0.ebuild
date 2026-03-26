src_install() {
    dodir /usr/local/bin
    dodir /etc/udev/rules.d

    #Detect backlight
    if [ ! -d /sys/class/backlight ]; then
        ewarn "No backlight interface found. Aborting."
        die
    fi

    BACKLIGHT=$(ls /sys/class/backlight | head -n1)

    if [ -z "${BACKLIGHT}" ]; then
        ewarn "No backlight device detected. Aborting."
        die
    fi

    einfo "Detected backlight device: ${BACKLIGHT}"

    BACKLIGHT_PATH="/sys/class/backlight/${BACKLIGHT}"

    #Optional group setup
    if use backlight_group; then
        if ! getent group backlight >/dev/null; then
            einfo "Creating backlight group..."
            groupadd backlight || die
        fi

        einfo "Setting permissions on ${BACKLIGHT_PATH}/brightness"
        chgrp backlight "${BACKLIGHT_PATH}/brightness" || ewarn "chgrp failed"
        chmod 0664 "${BACKLIGHT_PATH}/brightness" || ewarn "chmod failed"
    fi

    #Install script
    dobin "${FILESDIR}/backlight.sh"

    #Generate udev rule dynamically
    einfo "Generating udev rule for ${BACKLIGHT}"

    cat > "${D}/etc/udev/rules.d/90-backlight.rules" <<EOF
SUBSYSTEM=="backlight", KERNEL=="${BACKLIGHT}", GROUP="backlight", MODE="0664"
EOF

    einfo "Installation complete."

    if use backlight_group; then
        ewarn "Add your user to the backlight group:"
        ewarn "  gpasswd -a \$USER backlight"
    fi

    ewarn "Set keybindings manually in your DE."
}
