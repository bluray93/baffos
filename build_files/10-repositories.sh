#!/usr/bin/env bash

set -ouex pipefail

release="$(rpm -E %fedora)"

sed -i '/^max_parallel_downloads=/d' /etc/dnf/dnf.conf
sed -i '/^\[main\]/a max_parallel_downloads=10' /etc/dnf/dnf.conf

dnf5 -y install curl

enable_copr() {
    local owner_repo="$1"
    local owner="${owner_repo%/*}"
    local repo="${owner_repo#*/}"
    local target="/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:${owner}:${repo}.repo"

    [[ -f "${target}" ]] && return 0
    curl -fsSL \
        "https://copr.fedorainfracloud.org/coprs/${owner}/${repo}/repo/fedora-${release}/${owner}-${repo}-fedora-${release}.repo" \
        -o "${target}"
}

enable_copr bieszczaders/kernel-cachyos
enable_copr avengemedia/dms
enable_copr peterwu/rendezvous
