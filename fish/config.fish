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