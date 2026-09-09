#!/usr/bin/env bash

set -ouex pipefail

dnf5 -y upgrade 'qt6-*'

dnf5 -y install \
    bibata-cursor-themes \
    cliphist \
    dms \
    dms-greeter \
    danksearch \
    dgop \
    greetd \
    matugen \
    niri \
    qt6-qtwayland \
    quickshell \
    swaybg \
    swayidle \
    swaylock \
    wev \
    wl-clipboard \
    wlr-randr \
    xdg-desktop-portal \
    xdg-desktop-portal-gnome \
    xdg-desktop-portal-gtk \
    xorg-x11-server-Xwayland

mkdir -p /etc/skel/.config/niri
cp -f /ctx/dot_config/niri/config.kdl /etc/skel/.config/niri/config.kdl

mkdir -p /etc/skel/.config/systemd/user/graphical-session.target.wants
ln -sf /usr/lib/systemd/user/dms.service \
    /etc/skel/.config/systemd/user/graphical-session.target.wants/dms.service
ln -sf ../dms-setup.service \
    /etc/skel/.config/systemd/user/graphical-session.target.wants/dms-setup.service

glib-compile-schemas /usr/share/glib-2.0/schemas/
