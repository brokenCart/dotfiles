#!/usr/bin/env bash
# Toggle Bluetooth on/off (used by waybar's bluetooth module on right-click).
# Turning on also clears the rfkill soft-block, which is how the laptop's
# airplane-mode / Fn key leaves it.
if bluetoothctl show 2>/dev/null | grep -q 'Powered: yes'; then
    bluetoothctl power off >/dev/null
else
    rfkill unblock bluetooth
    sleep 0.5   # give the adapter a moment to come up after unblocking
    bluetoothctl power on >/dev/null
fi
