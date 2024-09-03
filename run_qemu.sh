#!/bin/bash

echo "generating hashed rootpwd for 'chameleon'"
rootpwd=$(openssl passwd -1 -stdin <<< chameleon)

qemu-system-x86_64 \
  -nographic \
  -m 2G \
  -accel kvm \
  -kernel output/ironic-python-agent/chi-ipa-debian.kernel \
  -initrd output/ironic-python-agent/chi-ipa-debian.initramfs \
  -append "root=/dev/ram0 console=ttyS0 rootpwd=\"${rootpwd}\""
