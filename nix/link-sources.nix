{
  config,
  lib,
  pkgs,
}:
let
  # Return a (path: type: bool) predicate from root/.gitignore.
  # Interpret patterns relative to root; a missing file permits all paths.
  gitignoreFilterFor =
    root:
    let
      ignoreFile = root + "/.gitignore";
      rules = lib.optionalString (builtins.pathExists ignoreFile) (builtins.readFile ignoreFile);
    in
    pkgs.nix-gitignore.gitignoreFilter rules root;

  checkoutRoot = /. + config.dotfiles.checkout;

  # Combine ignore rules from the checkout root through root.
  # A directory's rules cannot override exclusions imposed by its ancestors.
  filterForDirectory =
    root:
    let
      localFilter = gitignoreFilterFor root;
      parentFilter = if root == checkoutRoot then (_: _: true) else filterForDirectory (/. + builtins.dirOf (toString root));
    in
    path: type: parentFilter path type && localFilter path type;

  # List original file paths beneath source without copying contents into the store.
  # Apply ignore rules from each entry's containing directories; rejected directories are not traversed.
  filesFor =
    source:
    lib.fileset.toList (
      lib.fileset.fromSource (
        lib.cleanSourceWith {
          src = source;
          filter = path: type: filterForDirectory (/. + builtins.dirOf path) path type;
        }
      )
    );

in
{
  source, # File or directory relative to dotfiles.checkout.
  directory, # Absolute destination directory.
}:
let
  sourcePath = /. + "${config.dotfiles.checkout}/${source}";
  isDirectory = lib.pathIsDirectory sourcePath;
  files = if isDirectory then filesFor sourcePath else [ sourcePath ];
  # Strip the source root for directories, or the parent path for single files.
  sourcePrefix = "${if isDirectory then toString sourcePath else builtins.dirOf (toString sourcePath)}/";
in
lib.listToAttrs (
  map (file: {
    # Absolute keys are accepted by both home.file and xdg.configFile.
    name = "${directory}/${lib.removePrefix sourcePrefix (toString file)}";
    # Keep links editable and allow modules to override their sources.
    value.source = lib.mkDefault (config.lib.file.mkOutOfStoreSymlink (toString file));
  }) files
)
