function fix-ssh-agent
    set -l socket (env -u SSH_AUTH_SOCK refresh-ssh-agent); or return

    set -gx SSH_AUTH_SOCK $socket
    echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
end
