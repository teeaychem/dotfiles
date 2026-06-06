c-ts-base-mode

(dereference "->")
(reference "&")

;; https://gligan.net/emacs-config
(guard "#ifndef " (r (upcase (file-name-base (buffer-name))) header-name) "_H" n
       "#define " header-name "_H" n n
       q n n
       "#endif  /* " header-name "_H */" n)
