#!/bin/sh
CURRENT=$(powerprofilesctl get)

case "$1" in
    eco)        TARGET="power-saver" ;;
    balanced)   TARGET="balanced" ;;
    performance) TARGET="performance" ;;
esac

if [ "$CURRENT" = "$TARGET" ]; then
    CLASS="active"
else
    CLASS="inactive"
fi

# Возвращаем JSON с class
echo "{\"class\":\"$CLASS\"}"