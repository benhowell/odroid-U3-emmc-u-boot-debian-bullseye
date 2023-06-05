# odroid-U3-emmc-u-boot-debian-bullseye
u-boot flashing script and files to create (fix) u-boot on emmc for odroid U2 and U3 boards to run debian bullseye.


* Follow instructions to add Debian Bullseye server to your emmc card: https://forum.odroid.com/viewtopic.php?f=79&t=45448
  * NOTE: I had to keep the kernel locked to the original (i.e. block kernel upgrades) due to kernel panic with newer kernels, not sure why, YMMV.

* Plug emmc into the sd card slot using the emmc/sd converter and let it boot (there are some scripts that run on first boot that resize partitions, etc.)

* Download the files in this repo to your emmc card (either from the odroid debian install itself, or on another machine by mounting the emmc and copying files over).

* With the emmc still in the sd slot, execute `sd_fusing.sh` to flash a new u-boot to the boot partition. When complete, `poweroff`.

* Boot odroid with emmc card plugged in to the emmc slot. If everything went according to plan, debian bullseye should now boot from emmc. 

* Enjoy your vintage single board computer with a modern OS.
