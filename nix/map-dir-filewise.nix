{ lib, directory }:
# Link files individually to apply exclusions and keep generated state and local additions
# outside the checkout.
{
  # Live checkout directory, used for discovery and link sources.
  source,
  # Destination directory within the destination root (`directory`).
  target,
  exclude ? [
    ".DS_Store"
    ".homedir"
  ],
}:
let
  sourcePrefix = "${toString source}/";
  # The file declaration supplies the root, so strip it from the target path.
  targetPrefix = lib.removePrefix "${directory}/" "${target}/";
  # Preserve the source tree layout beneath both the target and checkout.
  relativeFiles = map (file: lib.removePrefix sourcePrefix (toString file)) (
    lib.filesystem.listFilesRecursive source
  );
  # Exclude matching file or directory names at any depth.
  included = relative: !lib.any (name: builtins.elem name exclude) (lib.splitString "/" relative);
in
lib.listToAttrs (
  map (relative: {
    name = targetPrefix + relative;
    value = sourcePrefix + relative;
  }) (builtins.filter included relativeFiles)
)
