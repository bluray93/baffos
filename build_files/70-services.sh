#!/usr/bin/env bash

set -ouex pipefail

rm -f /etc/systemd/system/display-manager.service
ln -s /usr/lib/systemd/system/greetd.service /etc/systemd/system/display-manager.service

systemctl enable \
    NetworkManager.service \
    bluetooth.service \
    greetd.service \
    podman.socket \
    sshd.service

systemctl set-default graphical.target

if systemctl list-unit-files virtqemud.service >/dev/null 2>&1; then
    systemctl enable virtqemud.service
elif systemctl list-unit-files libvirtd.service >/dev/null 2>&1; then
    systemctl enable libvirtd.service
fi
