set -gx CARGO_HOME "$HOME/.cargo"

if test -r "$CARGO_HOME/env.fish"
    source "$CARGO_HOME/env.fish"
else if test -d "$CARGO_HOME"
    fish_add_path "$CARGO_HOME/bin"
end
