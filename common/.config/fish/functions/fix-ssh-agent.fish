function __fix_ssh_agent_socket_usable --argument-names sock
    test -S "$sock"; or return 1

    if command -q ssh-add
        env SSH_AUTH_SOCK="$sock" ssh-add -l >/dev/null 2>&1
        set -l ssh_add_status $status
        contains -- "$ssh_add_status" 0 1
        return $status
    end

    return 0
end

function fix-ssh-agent
    set -l stable_sock "$HOME/.ssh/ssh_auth_sock"
    if set -q SSH_AUTH_SOCK_STABLE; and test -n "$SSH_AUTH_SOCK_STABLE"
        set stable_sock "$SSH_AUTH_SOCK_STABLE"
    end

    set -l source_sock

    if set -q SSH_AUTH_SOCK; and test -n "$SSH_AUTH_SOCK"; and test "$SSH_AUTH_SOCK" != "$stable_sock"; and __fix_ssh_agent_socket_usable "$SSH_AUTH_SOCK"
        set source_sock "$SSH_AUTH_SOCK"
    end

    if test -z "$source_sock"
        set -l candidates /tmp/ssh-*/agent.*

        if test (count $candidates) -gt 0
            for index in (seq (count $candidates) -1 1)
                test -S "$candidates[$index]"; or set -e candidates[$index]
            end
        end

        if test (count $candidates) -gt 1; and command -q ls
            set candidates (command ls -t -- $candidates 2>/dev/null)
        end

        for candidate in $candidates
            test "$candidate" = "$stable_sock"; and continue

            if __fix_ssh_agent_socket_usable "$candidate"
                set source_sock "$candidate"
                break
            end
        end
    end

    if test -z "$source_sock"; and set -q SSH_AUTH_SOCK; and test -n "$SSH_AUTH_SOCK"; and __fix_ssh_agent_socket_usable "$SSH_AUTH_SOCK"
        set source_sock "$SSH_AUTH_SOCK"
    end

    if test -z "$source_sock"
        echo "Unable to find a usable SSH agent socket" >&2
        return 1
    end

    mkdir -p (dirname "$stable_sock"); or return 1

    if test "$source_sock" != "$stable_sock"
        ln -snf "$source_sock" "$stable_sock"; or return 1
    end

    set -gx SSH_AUTH_SOCK "$stable_sock"

    if set -q TMUX; and command -q tmux
        tmux setenv -g SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
    end

    echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
end
