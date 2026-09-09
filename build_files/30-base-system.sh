#!/usr/bin/env bash

set -ouex pipefail

dnf5 -y install \
    NetworkManager \
    NetworkManager-wifi \
    accountsservice \
    android-tools \
    bluez \
    bluez-tools \
    brightnessctl \
    dbus-tools \
    fprintd-pam \
    flatpak \
    flatpak-builder \
    gnome-keyring \
    gvfs \
    gvfs-afc \
    gvfs-archive \
    gvfs-fuse \
    gvfs-goa \
    gvfs-gphoto2 \
    gvfs-mtp \
    gvfs-smb \
    iotop \
    just \
    lxpolkit \
    lxqt-openssh-askpass \
    openssh-server \
    parallel \
    pipewire \
    pipewire-alsa \
    pipewire-gstreamer \
    pipewire-pulseaudio \
    playerctl \
    podman-compose \
    polkit \
    seahorse \
    sysstat \
    udisks2 \
    unzip \
    upower \
    power-profiles-daemon \
    wireplumber \
    xdg-user-dirs
