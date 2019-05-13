# Raspberry Pi
Consists of a `prepare.sh` script and supporting scripts that will prepare an SD card containing a specified version of Rasbian (well, any ubuntu-based distro really)

## Prepare
`cd` to this directory and prepare an SD card with `sudo ./prepare.sh {options}`

### Options
* `-i` or `--image`: Required.  Path to the Rasbian image
* `-d` or `--device`: Required. Path to the SD card device. `*`
* `-h` or `--hostname`: Specify a hostname to setup for the Pi
* `-w` or `--wpa`: Path to a wpa_supplicant file to use.  This file must be a properly and fully configured wpa_supplicant (ie. it doesn't append this file... it overwrites it)

`*` Note that this script currently assumes you're using an SD Card reader and that it presents device partitions as `p1` and `p2`.

### What it does
The prepare script:
* Writes the image to the SD card.
* Copies the wpa_supplicant file to the boot partition in order to enable wifi
* Creates the `ssh` file needed to enable SSH on first boot
* Copies over the `install.sh` and `secure.sh` scripts to the `pi` user home directory.

## Install
Once logged into the Pi, run with `sudo ./install.sh` from the `pi` users home directory.

## What it does
* Update + Upgrades
* Installs and configures UFW (only allowing SSH by default)
* Installs Rust + Cargo
* Installs superintendent-quotes (for shell logins... just spits out random superintendent quotes)
* Installs Docker
* Creates the .ssh folder for the `pi` user and creates two authorized_key files.  One is managed by sshb0t and pulls public keys from Github.
* Pulls and sets up a container for sshb0t.

## Secure
Once ssh key access is confirmed and working, run with `sudo ./secure.sh` from the `pi` users home directory.

### What it does
Adds some security to the SSH Daemon.  Disables root login and passwords leaving only public keys for access.
