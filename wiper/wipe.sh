#!/bin/bash
# Trashes all locally mounted disks.
#
# FOR THE LOVE OF GOD DO NOT RUN THIS OUTSIDE OF A VM

if [[ "${UID}" == 0 ]]; then
   grep -E "^/dev" /proc/mounts \
     | cut -d" " -f1 \
     | sort -u \
     | xargs -P8 -I{} echo sudo dd if=/dev/zero of={}
else
   echo "Have a great day!"
fi

