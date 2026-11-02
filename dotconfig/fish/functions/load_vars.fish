function load_vars --argument-names vars_file
    if not test -f "$vars_file"
        echo "Error: Variables file '$vars_file' does not exist or was not specified." >&2
        return 1
    end

    while read -l line
        set -l name (string trim -- "$line")
        string match -q -r '^(#|$)' -- "$name"; and continue

        if not string match -q -r '^[A-Za-z_][A-Za-z0-9_]*$' -- "$name"
            echo "Warning: Ignoring malformed line in '$vars_file': $line" >&2
            continue
        end

        set -q $name; or set -g $name ''
    end < "$vars_file"
end
