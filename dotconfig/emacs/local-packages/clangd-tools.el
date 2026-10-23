;;; clangd-tools.el --- Discover Clang drivers for clangd -*- lexical-binding: t; -*-

;;; Commentary:

;; Find Clang driver paths for clangd's --query-driver allowlist, including
;; versioned executables, symlinks and matching cc/c++ aliases.

;;; Code:

(require 'cl-lib)
(require 'subr-x)

(defun clangd-tools--path-variants (path)
  "Return PATH and its canonical path when PATH is executable."
  (when (and path (file-executable-p path)) (delete-dups (list (expand-file-name path) (file-truename path)))))

(defun clangd-tools--find-executables (names directories)
  "Find executable NAMES in DIRECTORIES and on `exec-path'."
  (let ((local (cl-loop for directory in directories
                        append (cl-loop for name in names
                                        for path = (expand-file-name name directory)
                                        when (file-executable-p path)
                                        collect path)))
        (on-path (delq nil (mapcar #'executable-find names))))
    (delete-dups (append local on-path))))

(defun clangd-tools--compiler-names (clangd)
  "Return standard compiler names matching CLANGD's version, if any."
  (let (versioned)
    (dolist (path (clangd-tools--path-variants clangd))
      (when-let* ((name (file-name-nondirectory path))
                  ((string-match "\\`clangd\\(.+\\)\\'" name))
                  (suffix (match-string 1 name)))
        (push (concat "clang" suffix) versioned)
        (push (concat "clang++" suffix) versioned)))
    (delete-dups (append '("clang" "clang++") (nreverse versioned)))))

(defun clangd-tools--compiler-aliases (drivers directories)
  "Find cc/c++ aliases in DIRECTORIES and `exec-path' that resolve to DRIVERS."
  (let ((canonical-drivers (mapcar #'file-truename drivers)))
    (cl-loop for alias in (clangd-tools--find-executables '("cc" "c++") directories)
             when (member (file-truename alias) canonical-drivers)
             collect alias)))

;;;###autoload
(defun clangd-tools-query-drivers (clangd)
  "Return trusted Clang driver paths associated with CLANGD.

Both the symlink spelling and canonical path are included because compilation databases may use either.
`cc' and `c++' are included only when they resolve to one of the discovered Clang drivers."
  (let* ((clangd-paths (clangd-tools--path-variants clangd))
         (directories (delete-dups (mapcar #'file-name-directory clangd-paths)))
         (names (clangd-tools--compiler-names clangd))
         (drivers (clangd-tools--find-executables names directories))
         (aliases (clangd-tools--compiler-aliases drivers directories)))
    (delete-dups (mapcan #'clangd-tools--path-variants (append drivers aliases)))))

(provide 'clangd-tools)
;;; clangd-tools.el ends here
