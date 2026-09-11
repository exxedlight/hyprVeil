source /usr/share/cachyos-fish-config/cachyos-config.fish

alias mysql='mariadb --prompt="mysql [\d]> "'

if not set -q SSH_AGENT_PID
    eval (ssh-agent -c >/dev/null)
end

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

set -x npm_config_cache "$HOME/.cache/npm"


function finish-him
    canberra-gtk-play -f ~/Env/Sounds/finish-him.wav >/dev/null 2>&1
    killall -9 $argv[1]
    set_color -b black red --bold
    echo "  === FATALITY ===  "
    set_color normal
end


function yt-dlp-audio
    # 1 - Quality
    # 2 - Save path
    # 3 - URL
    # 4 - Playlist
    # 5 - Cookies? (optional, any value triggers it)
    set -l cookie_args
    if set -q argv[5]
        set cookie_args --cookies '/home/exxedlight/OWN/cookies.txt'
    end
 
    yt-dlp -f 'ba' -x --audio-format mp3 --audio-quality $argv[1]k -o '%(title)s.%(ext)s' -P $argv[2] $cookie_args $argv[3] $argv[4]
end

function yt-dlp-video
    # 1 - URL
    # 2 - Height
    # 3 - Cookies? (optional, any value triggers it)
    set -l cookie_args
    if set -q argv[3]
        set cookie_args --cookies '/home/exxedlight/OWN/cookies.txt'
    end
 
    yt-dlp $argv[1] -f "bv*[height=$argv[2]]+ba" -P "/home/exxedlight/Downloads/" -t mp4 --no-playlist -o '%(title)s.%(ext)s' $cookie_args
end