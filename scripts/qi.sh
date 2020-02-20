#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset


if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

BINNAME=cloud-torrent
BINPATH=/usr/local/bin
REPOSITORYNAME=boypt/simple-torrent
OSARCH=$(uname -m)
case $OSARCH in 
    x86_64)
        BINTAG=linux_amd64
        ;;
    i*86)
        BINTAG=linux_386
        ;;
    arm64|aarch64)
        BINTAG=linux_arm64
        ;;
    arm*)
        BINTAG=linux_arm
        ;;
    *)
        echo "unsupported OSARCH: $OSARCH"
        exit 1
        ;;
esac

wget $WGETPROXY -qO- https://api.github.com/repos/$REPOSITORYNAME/releases/latest \
| grep browser_download_url | grep "$BINTAG" | cut -d '"' -f 4 \
| wget $WGETPROXY --no-verbose -i- -O- | gzip -d -c > $BINPATH/$BINNAME
chmod 0755 $BINPATH/$BINNAME
