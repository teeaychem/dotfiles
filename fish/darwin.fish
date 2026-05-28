if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
end

fish_add_path --append "/opt/homebrew/opt/llvm/bin/"
fish_add_path "$HOME/.local/opt/emacs/bin/"
fish_add_path "$HOME/.local/opt/elan/bin/"
fish_add_path "/usr/local/texlive/2026basic/bin/universal-darwin/"

set -gx HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/brew/Brewfile"
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_ENV_HINTS 1

if command -q bat
    set -gx HOMEBREW_BAT 1
end

function cdf
    cd (osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')
end

function dq
    xattr -r -d com.apple.quarantine $argv[1]
end

function rmdsstore
    set -l roots $argv
    test (count $roots) -gt 0; or set roots .
    find $roots -type f -name .DS_Store -delete
end
