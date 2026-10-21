# export LDFLAGS="-L/opt/homebrew/opt/llvm/lib -L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib/unwind -lunwind"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
# export CMAKE_PREFIX_PATH="/opt/homebrew/opt/llvm"

# Change working directory to the top finder window location
function cdf() {
    local finder_dir
    finder_dir="$(finder-pwd)" || return

    [[ -n "$finder_dir" ]] || return 1
    cd "$finder_dir"
}
