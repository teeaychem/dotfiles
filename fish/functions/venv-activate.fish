function venv-activate
    set -l venv_root $argv[1]
    test -n "$venv_root"; or set venv_root .venv

    set venv_root (string replace -r '/$' '' -- "$venv_root")

    if test -f "$venv_root/bin/activate.fish"
        source "$venv_root/bin/activate.fish"
        echo "Activated venv: $venv_root"
    else
        echo "Unable to activate venv: $venv_root" >&2
        return 1
    end
end
