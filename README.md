# This is a custom fork, which integrates new HPLIP drivers for LaserJet MFP M139-M141

## How to build

```bash
BUILDKIT_STEP_LOG_MAX_SIZE=-1
BUILDKIT_STEP_LOG_MAX_SPEED=-1
docker buildx build -f Dockerfile -t hovo:test . --output type=docker


# it recreates all the time
docker buildx build -f Dockerfile -t hovo:test .  --builder "$(docker buildx create --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=-1 --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=-1)"


docker buildx create --bootstrap --use --name buildkit \
    --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=-1 \
    --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=-1

docker buildx build --progress plain -f Dockerfile -t hovo:test .


# now run this build

docker run \
  --detach \
  --publish 8080:8080 \
  --volume /var/run/dbus:/var/run/dbus \
  --volume /dev/bus/usb:/dev/bus/usb \
  --restart unless-stopped \
  --name scanservjs-container \
  --privileged hovo:test

# debug outside docker
 docker exec -it scanservjs-container /bin/bash
 scanimage -L


scanimage --device "hpaio:/usb/HP_LaserJet_MFP_M139-M142?serial=VNF5347117" --format=png > scan.png


sudo systemctl restart saned.socket
sudo sane-find-scanner



# create udev rule

lsusb
Bus 001 Device 005: ID 03f0:0372 HP, Inc HP LaserJet MFP M139-M142



# -- *Part 1 For Garni Printer
RUN echo 'SYSFS{idVendor}=="03f0", MODE="0666", GROUP="scanner", ENV{libsane_matched}="yes"' >/etc/udev/rules.d/55-libsane.rules

# -- * PART 2  Garni Printer

RUN echo 'usb 0x03f0 0x0372' >> /etc/sane.d/hp.conf


# restart udev rules
RUN udevadm control --reload-rules;udevadm trigger


# outside docker
echo 'SYSFS{idVendor}=="03f0", MODE="0666", GROUP="scanner", ENV{libsane_matched}="yes"' | sudo tee /etc/udev/rules.d/55-libsane.rules
echo 'usb 0x03f0 0x0372' | sudo tee /etc/sane.d/hp.conf
sudo udevadm control --reload-rules;udevadm trigger


# sudo test
sudo scanimage -L
sudo scanimage --device "hpaio:/usb/HP_LaserJet_MFP_M139-M142?serial=VNF5347117" --format=png > scan.png


# regular user
export SANE_DEBUG_HPAIO=128
scanimage -L
scanimage --device "hpaio:/usb/HP_LaserJet_MFP_M139-M142?serial=VNF5347117" --format=png > scan.png



# permission
sudo chmod a+rw /dev/bus/usb/002/003


Running './configure --with-hpppddir=/usr/share/ppd/HP --libdir=/usr/lib --prefix=/usr --enable-network-build --enable-scan-build --enable-fax-build --enable-dbus-build --disable-qt4 --disable-qt5 --disable-class-driver --enable-doc-build --disable-policykit --disable-libusb01_build --disable-udev_sysfs_rules --enable-hpcups-install --disable-hpijs-install --disable-foomatic-ppd-install --disable-foomatic-drv-install --disable-cups-ppd-install --enable-cups-drv-install --enable-apparmor_build'

hp-check -t
sudo usermod -aG lp,scanner $USER


https://askubuntu.com/questions/153746/xsane-failed-to-open-device-hpaio-net-photosmart-c5100-serieszc-hp5180-err
hp-plugin


# still error
[hpaio] sane_hpaio_open(/usb/HP_LaserJet_MFP_M139-M142?serial=VNF5347117): scan/sane/hpaio.c 395 scan_type=9 scansrc=1
error: SANE: Error during device I/O (code=9)



# after restart run hp-setup

sudo apt install apparmor-utils
sudo aa-disable /usr/share/hplip/plugin.py
hp-plugin

# maybe just use internal ubuntu hplip and stop compiling stupid HPLIP new version
https://developers.hp.com/hp-linux-imaging-and-printing/plugins

hp-plugin -p hplip-3.25.2-plugin.run -i


sudo apt install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools




hp-scan works that is a progress
hp-scan[3472]: debug: getDeviceUri(None, None, ['hpaio'], {'scan-type': (<built-in function gt>, 0)}, , True)
hp-scan[3472]: debug: Mode=0
warning: No destinations specified. Adding 'file' destination by default.
Using device hpaio:/usb/HP_LaserJet_MFP_M139-M142?serial=VNF5347117



https://linuxcapable.com/how-to-install-lxqt-on-ubuntu-linux/

after that install plugin
abmin@siriprint:~/Apps$ scanimage -L
device `hpaio:/usb/HP_LaserJet_MFP_M139-M142?serial=VNF5347117' is a Hewlett-Packard HP_LaserJet_MFP_M139-M142 all-in-one
```

# scanservjs

[![Build Status](https://img.shields.io/github/actions/workflow/status/sbs20/scanservjs/build.yml?branch=master&style=for-the-badge)](https://github.com/sbs20/scanservjs/actions)
[![Code QL Status](https://img.shields.io/github/actions/workflow/status/sbs20/scanservjs/codeql-analysis.yml?branch=master&style=for-the-badge&label=CodeQL)](https://github.com/sbs20/scanservjs/actions)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/sbs20/scanservjs?style=for-the-badge)](https://hub.docker.com/r/sbs20/scanservjs)
[![Docker Pulls](https://img.shields.io/docker/pulls/sbs20/scanservjs?style=for-the-badge)](https://hub.docker.com/r/sbs20/scanservjs)
[![GitHub stars](https://img.shields.io/github/stars/sbs20/scanservjs?label=Github%20stars&style=for-the-badge)](https://github.com/sbs20/scanservjs)
[![GitHub](https://img.shields.io/github/license/sbs20/scanservjs?style=for-the-badge)](https://github.com/sbs20/scanservjs/blob/master/LICENSE.md)

![screenshot](https://github.com/sbs20/scanservjs/raw/master/docs/screen0.jpg)

Copyright 2016-2023 [Sam Strachan](https://github.com/sbs20)

## What people are saying

> I've decided to switch to using only this, I find using this in a browser is
> just perfect and way better than bloated software from printer manufacturers


> It enabled me to still use my old hp3900 scanner without worrying about
> drivers and vendor specific UIs. Furthermore, scans just being accessible via
> an awesome web interface makes it even more brilliant!


> This is a great project! The touchscreen and buttons on my Brother scanner are
> broken, meaning the device is useless by itself because one cannot trigger
> scans, but with this project I can trigger it remotely just fine.


> Absolutely love untethering my scanner from my laptop. Also means that I know
> it will work "forever", regardless of OS updates, since its all just a docker
> container.

## About

scanservjs is a web UI frontend for your scanner. It allows you to share one or
more scanners (using SANE) on a network without the need for drivers or
complicated installation.

## Features

* Cropping
* Source selection (Flatbed / ADF)
* Resolution
* Output formats (TIF, JPG, PNG, PDF and TXT with Tesseract OCR) with varying
  compression settings
* Filters: Autolevels, Threshold, Blur
* Configurable overrides for all defaults as well as filters and formats
* Multipage scanning (with collation for double sided scans)
* International translations: Arabic, Czech, Dutch, French, German, Hungarian,
  Italian, Mandarin, Polish, Portuguese (PT & BR), Russian, Slovak, Spanish,
  Turkish, Ukrainian;
  [Help requested](https://github.com/sbs20/scanservjs/issues/154)
* Light and dark mode
* Responsive design
* Docker images for `amd64`, `arm64` and `armv7`
* OpenAPI documentation

It supports any
[SANE compatible devices](http://www.sane-project.org/sane-supported-devices.html).

## Requirements

* SANE Scanner
* Linux host (or VM with necessary pass-through e.g. USB)
* Software sane-utils, ImageMagick, Tesseract and nodejs

## Install

* Debian:
  ```sh
  curl -s https://raw.githubusercontent.com/sbs20/scanservjs/master/bootstrap.sh | sudo bash -s -- -v latest
  ```
* Arch:
  ```sh
  yay -S scanservjs
  ```
* Docker:
  ```sh
  docker run \
    --detach \
    --publish 8080:8080 \
    --volume /var/run/dbus:/var/run/dbus \
    --restart unless-stopped \
    --name scanservjs-container \
    --privileged sbs20/scanservjs:latest
  ```

## Documentation

### Installation and setup

* [Standard install](docs/01-install.md)
* [Docker install](docs/02-docker.md)
* [SANE setup](docs/03-sane.md)
* [Troubleshooting](docs/04-troubleshooting.md)

### Configuration

* [Configuration](docs/10-configuration.md)
* [Integration](docs/11-integration.md)
* [Recipes](docs/12-recipes.md)
* [Using a proxy](docs/13-proxy.md)

### Developing

* [Development](docs/50-development.md)
* [Localisation](docs/51-localisation.md)
* [Testing](docs/60-testing.md)
* [References](docs/90-references.md)
* [QNAP](docs/91-qnap.md)

## Running scanservjs

In most cases the use of the app should be fairly self-explanatory. When the app
first loads, it attempts to detect your scanner - this step is the most
precarious and may either require custom drivers or some additional steps if
you're running a network scanner or docker. See the documentation above for
more.

Once the scanner is detected then you have a number of pages.

### Scan

This page gives access to the controls for your scanner. The app will generally
find the settings available automatically, although some scanners mis-report
their abilities. (If this is the case, then you can override what's detected,
see [Configuration and device override](docs/10-configuration.md) for more). If
geometry is available (selecting scan size and position) then you will have
cropping available to you.

There is also the ability to perform batch scanning. If you have a document
feeder, then just use the `Auto` option. If not then use `Manual` and the app
will prompt you to change pages between scans.

Any scan operation will always result in a single file. Some image formats, such
as PDF and TIF support multiple pages, while others, such as PNG and JPG do not.
If the scan pipeline results in more than one file, then the app will zip the
files into a single output. You can choose the image format under `Format`.

You can create and customise your own pipelines.

### Files

Any scanned files will be saved in a flat directory which has a simple web view
available on this page. The intended usage of the app is to allow the user to
save their scans locally - i.e. to download the files. The app will never delete
these files, but if you run under docker then unless volume mapping is specified
then the files may be lost when you run a new version.

Furthermore, users in real life will want to store their scans with their own
names, directory structures and cloud services or NAS devices. The permutations
and possibilities are endless and are beyond the scope of the app.

scanservjs can integrate files either through pipeline automation or file
actions. See [integration documentation](docs/11-integration.md) for more.

### Settings

The settings page allows you to change the appearance and locale / language.

### About

Copyright information and system info.

## OpenAPI documentation

There is built in OpenAPI documentation with an API explorer. Access it direct
using `/api-docs` or navigate from the `About` page.

![OpenAPI](https://github.com/sbs20/scanservjs/raw/master/docs/swagger.png)

## Why?

This is yet another scanimage-web-front-end. Why? It originally started as an
adaptation of phpsane - just to make everything a bit newer, give it a refresh
and make it work on minimal installations without imagemagick - that version is
[still available](https://github.com/sbs20/scanserv) but is no longer
maintained. Since then, I just wanted to write it in node and enhance it a bit,
and it's been a labour of love ever since.

## Acknowledgements

 * This project owes its genesis to
   [phpsane](http://sourceforge.net/projects/phpsane/)
 * [Everyone](https://github.com/sbs20/scanservjs/graphs/contributors) who has
   filed issues, tested, fixed issues, added translations and helped over the
   years. Thank you!

## More about SANE

 * <http://www.sane-project.org/>
