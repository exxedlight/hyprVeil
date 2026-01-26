#!/bin/sh

# Путь к видео
VIDEO="~/Env/Wallpapers/Video/FireKeeper.mp4"
OUTPUT="eDP-1"

# Проверяем, запущен ли mpvpaper
if pgrep -x "mpvpaper" > /dev/null; then
    # Если да — убиваем и запускаем hyprpaper
    killall mpvpaper
    hyprpaper & disown
    #echo "{\"class\":\"static\"}"
    echo "static"
else
    # Если нет — убиваем hyprpaper и запускаем mpvpaper
    killall hyprpaper
    mpvpaper -o "--loop=inf --no-audio --hwdec=vaapi" "$OUTPUT" "$VIDEO" & disown
    #echo "{\"class\":\"video\"}"
    echo "video"
fi