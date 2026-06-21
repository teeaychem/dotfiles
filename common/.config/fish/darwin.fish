if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
end

function cdf
    set -l finder_dir (finder-pwd)
    or return

    test -n "$finder_dir"
    or return 1

    cd "$finder_dir"
end
