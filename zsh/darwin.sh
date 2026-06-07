eval "$(/opt/homebrew/bin/brew shellenv)"

# export LDFLAGS="-L/opt/homebrew/opt/llvm/lib -L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib/unwind -lunwind"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
# export CMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm"

export HOMEBREW_BUNDLE_FILE="${XDG_CONFIG_HOME}/brew/Brewfile"
export HOMEBREW_NO_AUTO_UPDATE
export HOMEBREW_NO_ENV_HINTS=1

if command -v bat &>/dev/null; then export HOMEBREW_BAT=1; fi

# Change working directory to the top finder window location
function cdf() {
    local finder_dir
    finder_dir="$(finder-pwd)" || return

    [[ -n "$finder_dir" ]] || return 1
    cd "$finder_dir"
}
