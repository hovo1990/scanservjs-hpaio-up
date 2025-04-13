
# -- * https://github.com/jacobalberty/cups-docker/blob/master/drivers/hplip.sh
BUILD_DEPS="\
    build-essential \
    curl \
    equivs \
    gawk \
    libavahi-core-dev \
    libavahi-client-dev \
    libdbus-1-dev \
    libjpeg62-turbo-dev \
    libsnmp-dev \
    libssl-dev \
    libusb-1.0-0-dev \
    python3-dev"

DEPS="\
    avahi-daemon \
    dbus \
    gpg \
    python3 \
    python3-dbus \
    wget \
    libcups2 cups \
    libcups2-dev cups-bsd cups-client \
    avahi-utils libavahi-client-dev libavahi-core-dev \
    libavahi-common-dev libcupsimage2-dev libdbus-1-dev build-essential \
    gtk2-engines-pixbuf ghostscript openssl libjpeg-dev libatk-adaptor libgail-common \
    libsnmp-dev \
    libtool libtool-bin libusb-1.0-0-dev libusb-0.1-4 wget policykit-1 \
    policykit-1-gnome automake1.11 python3-dbus.mainloop.pyqt5 python3-reportlab python3-notify2 python3-pyqt5 \
    python3-dbus python3-gi python3-lxml python3-dev python3-pil python-is-python3 libsane libsane-dev sane-utils xsane"


apt-get update
apt-get -qy install ${BUILD_DEPS} ${DEPS}