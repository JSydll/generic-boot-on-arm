# Add mount points
dirs755 += "/data"

do_install:append() {
    rm ${D}${sysconfdir}/motd
}