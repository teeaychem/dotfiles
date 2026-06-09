function load_paths
    set -l paths_file $argv[1]
    set -l parser "$XDG_CONFIG_HOME/shell/path/parse-paths"
    set -l records ($parser "$paths_file")
    or return

    for record in $records
        set -l fields (string split -m 1 \t -- "$record")
        set -l operation $fields[1]
        set -l directory $fields[2]
        set -l filtered

        for entry in $PATH
            test "$entry" = "$directory"; or set -a filtered "$entry"
        end

        set -gx PATH $filtered

        if test "$operation" = +
            set -gx PATH "$directory" $PATH
        end
    end
end
