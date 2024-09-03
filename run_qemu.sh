#!/bin/bash

echo "generating hashed rootpwd for 'chameleon'"
rootpwd=$(openssl passwd -1 -stdin <<< chameleon)

qemu-system-x86_64 \
  -nographic \
  -m 2G \
  -accel kvm \
  -kernel output/ipa-debian12-2023.1.kernel \
  -initrd output/ipa-debian12-2023.1.initramfs \
  -append "root=/dev/ram0 console=ttyS0 ipa-inspection-collectors=default,pci-devices,dmi-decode,numa-topology,extra-hardware,logs ipa-collect-lldp=1 rootpwd=\"${rootpwd}\""
