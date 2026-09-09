#!/usr/bin/env bash

set -ouex pipefail

dnf5 -y install \
    file-roller \
    ffmpeg \
    gnome-calculator \
    gnome-system-monitor \
    kitty \
    loupe \
    mpv \
    nautilus \
    obs-studio \
    x264-libs \
    xdg-utils \
    zenity \
    --allowerasing

# Kept intentionally: BaffOS already shipped local virtualization/developer tools.
dnf5 -y install \
    iperf3 \
    ktls-utils \
    libvirt \
    qemu-kvm \
    virt-manager
