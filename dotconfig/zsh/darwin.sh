# Change working directory to the top finder window location
function cdf() {
    local finder_dir
    finder_dir="$(finder-pwd)" || return

    [[ -n "$finder_dir" ]] || return 1
    cd "$finder_dir"
}
