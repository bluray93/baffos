#!/usr/bin/env bash

set -ouex pipefail

dnf5 -y install \
    libdrm \
    libva-intel-media-driver \
    libva-utils \
    libvdpau \
    mesa-dri-drivers \
    mesa-filesystem \
    mesa-libEGL \
    mesa-va-drivers \
    mesa-vulkan-drivers \
    vulkan-loader \
    vulkan-tools
