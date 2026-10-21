# hammerspoon
# defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

function cdf
    set -l finder_dir (finder-pwd)
    or return

    test -n "$finder_dir"
    or return 1

    cd "$finder_dir"
end
