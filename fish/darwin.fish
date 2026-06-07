if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
end

set -gx HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/brew/Brewfile"
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_ENV_HINTS 1

if command -q bat
    set -gx HOMEBREW_BAT 1
end

function cdf
    set -l finder_dir (finder-pwd)
    or return

    test -n "$finder_dir"
    or return 1

    cd "$finder_dir"
end
