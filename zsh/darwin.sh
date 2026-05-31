eval "$(/opt/homebrew/bin/brew shellenv)"

# llvm
path_add "/opt/homebrew/opt/llvm/bin/" "append"

# export LDFLAGS="-L/opt/homebrew/opt/llvm/lib -L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib/unwind -lunwind"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
# export CMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm"

path_add "/usr/local/texlive/2026basic/bin/universal-darwin/" "prepend"
path_add "${HOME}/.local/opt/emacs/bin/" "prepend"
path_add "${HOME}/.local/opt/elan/bin/" "prepend"

export HOMEBREW_BUNDLE_FILE="${XDG_CONFIG_HOME}/brew/Brewfile"
export HOMEBREW_NO_AUTO_UPDATE
export HOMEBREW_NO_ENV_HINTS=1

if command -v bat &>/dev/null; then export HOMEBREW_BAT=1; fi

# Change working directory to the top finder window location
function cdf() {
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# de-quarantine $1
function dq {
    xattr -r -d com.apple.quarantine "$1"
}

function rmdsstore {
    find "${@:-.}" -type f -name .DS_Store -delete
}
