#!/bin/bash

USAGE="pve-diff-backup.sh apply|revert"

error() {
  echo -ne "\n\e[1;31msomething went wrong\e[0m\n\n"
  exit 1
}

if [[ $# -eq 1 ]]; then

  DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  if [ -f /usr/bin/pveversion ]; then
    PVE_MAJOR_VERSION=$(pveversion | awk -F'/' '{print $2}' | sed 's,-[0-9]\+$,,')
  else
    echo "seems like this is not a PVE host"
    error
  fi

  if [ -f $DIR/patches/pve-${PVE_MAJOR_VERSION}-diff-backup-addon ]; then
    case $1 in
      apply|revert)
        bash $DIR/patches/pve-${PVE_MAJOR_VERSION}-diff-backup-addon $1 || error

        if [[ ! -f /usr/bin/xdelta3 ]]; then
          echo "xdelta3 (w/ LZOP enabled) missing, installing right now..."
          dpkg -i $DIR/packages/pve-xdelta3_3.0.6-1_amd64.deb || error
        fi
      ;;

      *)
        echo $USAGE
      ;;
    esac
  else
    echo "patches/pve-${PVE_MAJOR_VERSION}-diff-backup-addon missing"
  fi
else
  echo $USAGE
fi
