#!/bin/bash

# Push lime.ko to the device's sdcard
adb push lime.ko /sdcard/lime.ko

# Forward TCP port 4444 from the device to the host
adb forward tcp:4444 tcp:4444

# Start a shell session on the device
adb shell

# Switch to root user
su

# Check if the device supports loading kernel modules
MODULE_SUPPORT=$(cat /proc/sys/kernel/modules_disabled)

if [ "$MODULE_SUPPORT" = "0" ]; then
    # Load the lime.ko kernel module with the specified parameters
    insmod /sdcard/lime.ko "path=tcp:4444 format=lime"

    # Exit the shell session
    exit

    # Capture RAM dump from the device and save it to ram.lime
    nc localhost 4444 > ram.lime

    echo "RAM dump captured successfully."
else
    echo "Error: This device does not support loading kernel modules."
fi