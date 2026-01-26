#!/bin/sh

#case "$1" in
#    eco)
#        powerprofilesctl set power-saver
#        sudo cpupower frequency-set -u 1000000 >/dev/null
#        notify-send "Power" "Power plan: Power-Saver\nCPU limit: 1.0 GHz"
#        ;;
#    balanced)
#        powerprofilesctl set balanced
#       sudo cpupower frequency-set -u 2500000 >/dev/null
#        notify-send "Power" "Power plan: Balanced\nCPU limit: 2.5 GHz"
#        ;;
#    performance)
#        powerprofilesctl set performance
#        sudo cpupower frequency-set -u 3000000 >/dev/null
#        notify-send "Power" "Power plan: Performance\nCPU limit: 3.0 GHz"
#        ;;
#    *)
#        echo "Usage: $0 [eco|balanced|performance]" >&2
#        exit 1
#        ;;
#esac


case "$1" in
    eco)
        powerprofilesctl set power-saver
        FREQ=${2:-1000000}
        ;;
    balanced)
        powerprofilesctl set balanced
        FREQ=${2:-2500000}
        ;;
    performance)
        powerprofilesctl set performance
        FREQ=${2:-3000000}
        ;;
    *)
        echo "Usage: $0 [eco|balanced|performance] [freq_khz]" >&2
        exit 1
        ;;
esac

sudo cpupower frequency-set -u "$FREQ" >/dev/null
notify-send "Power" "Power plan: $(echo "$1" | sed 's/.*/\u&/')\nCPU limit: $(awk "BEGIN {printf \"%.1f\", $FREQ/1000000}") GHz"