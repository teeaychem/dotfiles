function fish_plugins_sync
    if not functions -q fisher
        if not command -q curl
            echo "Unable to install Fisher: curl is not available." >&2
            return 1
        end

        set -l fisher_url https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish
        set -l fisher_tmp (mktemp)
        or return 1

        curl --fail --location --silent --show-error "$fisher_url" --output "$fisher_tmp"
        or begin
            rm -f "$fisher_tmp"
            return 1
        end

        source "$fisher_tmp"
        set -l source_status $status
        rm -f "$fisher_tmp"

        test $source_status -eq 0
        or return $source_status

        if not functions -q fisher
            echo "Unable to install Fisher: downloaded function did not load." >&2
            return 1
        end

        fisher install jorgebucaran/fisher
        or return 1
    end

    fisher update
end
