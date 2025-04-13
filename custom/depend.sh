
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
    wget"


apt-get update
apt-get -qy install ${BUILD_DEPS} ${DEPS}