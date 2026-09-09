#!/usr/bin/env bash

set -ouex pipefail

cp -avf /ctx/system_files/. /

for script in /ctx/[0-9][0-9]-*.sh; do
    bash "${script}"
done
