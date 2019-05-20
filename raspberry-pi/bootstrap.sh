#!/bin/bash
# Assumes your post dd partition tables will be of format p1, p2, etc. (SD Card)
for i in "$@"; do
  case $i in
    -i=*|--image=*)
    IMAGE="${i#*=}"
    shift
    ;;
    -d=*|--device=*)
    DEVICE="${i#*=}"
    shift
    ;;
    -w=*|--wpa=*)
    WPAPATH="${i#*=}"
    shift
    ;;
  esac
done

if [ -z "$IMAGE" ]; then
  echo "Error -> You must specify a source path to a Raspberry Pi Image"
  echo "Exiting!"
  exit 1
fi

if [ -z "$DEVICE" ]; then
  echo "Error -> You must specify a target path to a device"
  echo "Exiting!"
  exit 1
fi

# TODO Need to automate partition gather
BOOT_PARTITION=p1
FILE_PARTITION=p2
BOOTMOUNTPATH=/tmp/pi-boot


echo "PI Image To Write=${IMAGE}"
echo "SD Card Device Path=${DEVICE}"
echo "Temporary Boot Mount Path=${BOOTMOUNTPATH}"
if [ -z "$WPAPATH" ]; then
  echo "WPA Supplicant Path=<Not Copying>"
else
  echo "WPA Supplicant Path=${WPAPATH}"
fi

promptForSanity() {
  read -p "Continue? (y/n)" -r ANSWER
  if [ ${ANSWER} != "y" ] && [ ${ANSWER} != "Y" ]; then
    echo "Aborting."
    exit 0
  fi
}

read -p "Check variables above to ensure accuracy!  THIS COULD DESTROY DATA!  Continue (y/n)? " -r ANSWER
echo #newww line
if [ $ANSWER = "y" ] || [ ${ANSWER} = "Y" ];
then
  echo "Welcome to the Danger Zone!"

  echo "About to DD using ${IMAGE} as source and ${DEVICE} as target.  THIS COULD DESTROY DATA!"
  promptForSanity
  echo "Running DD against ${DEVICE}"
  dd if=${IMAGE} of=${DEVICE}
  sync;
  echo "Refreshing parition list for device"
  partprobe ${DEVICE}

  echo "Mounting RPI boot directory."
  BOOT_PARTITION="${DEVICE}${BOOT_PARTITION}"
  echo "Mounting ${BOOT_PARTITION} to ${BOOTMOUNTPATH}"
  mkdir ${BOOTMOUNTPATH}
  mount ${BOOT_PARTITION} ${BOOTMOUNTPATH}

  # Enable SSH on boot.
  echo "Enabling SSH..."
  touch ${BOOTMOUNTPATH}/ssh

  if [ ! -z "${WPAPATH}" ]; then
    echo "Copying WPA Supplicant Config"
    cp ${WPAPATH} ${BOOTMOUNTPATH}/wpa_supplicant.conf
  fi

  echo "Unmounting ${BOOT_PARTITION}"
  umount ${BOOTMOUNTPATH}
  rmdir ${BOOTMOUNTPATH}

else
  echo "Aborting."
fi
