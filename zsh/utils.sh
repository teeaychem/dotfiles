function path_add {
    local target="${1%/}"
    if [[ -d "$target" ]] && (( ! ${PATH[(I)$target]} )); then
        case "$2" in
        "append")
            PATH="${PATH:+${PATH}:}$1"
            ;;
        "prepend")
            PATH="$1${PATH:+:${PATH}}"
            ;;
        "")
            PATH="$1${PATH:+:${PATH}}"
            ;;
        *)
            echo -e "Unexpected path_add specification: ${2}"
            ;;
        esac
    fi
}
