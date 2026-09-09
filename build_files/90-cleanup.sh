#!/usr/bin/env bash

set -ouex pipefail

if rpm -q waybar; then
    dnf5 -y remove waybar
fi

dnf5 -y clean all
sed -i 's/^enabled=1$/enabled=0/' /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:*.repo
rm -rf /run/dnf /run/selinux-policy /var/cache/dnf /var/lib/dnf
