==================
chi-ipa-autologin
==================

Opt-in element for DEBUG builds of the Chameleon IPA ramdisk. Configures
``serial-getty@ttyS0`` and ``getty@tty1`` to autologin as ``root`` with no
password, so you can drop straight into a shell on the console.

Do NOT ship this to production. Add it to the ``disk-image-create`` element
list only when building a debug image, e.g.::

    disk-image-create ... chi_ipa chi-ipa-autologin debian-minimal
