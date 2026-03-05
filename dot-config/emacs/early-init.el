;;; early-init.el -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil) ;; don't make installed packages available before loading init.el.

(setq load-prefer-newer t)
(setq native-comp-jit-compilation t) ;; native-compile .elc files asynchronously.
(setq native-comp-async-query-on-exit t)
(setq package-native-compile t)

(setq gc-cons-threshold (* 32 1024 1024))
(run-with-idle-timer 2.0 t 'garbage-collect)
(setq garbage-collection-messages nil)

(setq read-process-output-max (* 2 1024 1024))

(setq inhibit-compacting-font-caches t)


;; https://github.com/d12frosted/homebrew-emacs-plus/issues/323
;; (defun homebrew-gcc-paths ()
;;   "Return GCC library paths from Homebrew installations.
;; Detects paths for gcc and libgccjit packages to be used in LIBRARY_PATH."
;;   (let* ((paths '())
;;          (brew-bin (executable-find "brew")))

;;     (when brew-bin
;;       ;; Get gcc paths.
;;       (let* ((gcc-prefix (string-trim
;;                           (shell-command-to-string
;;                            (concat brew-bin " --prefix gcc"))))
;;              (gcc-lib-current (expand-file-name "lib/gcc/current" gcc-prefix)))
;;         (push gcc-lib-current paths)

;;         ;; Find apple-darwin directory.
;;         (let* ((default-directory gcc-lib-current)
;;                (arch-dirs (file-expand-wildcards "gcc/*-apple-darwin*/*[0-9]")))
;;           (when arch-dirs
;;             (push (expand-file-name
;;                    (car (sort arch-dirs #'string>)))
;;                   paths))))

;;       ;; Get libgccjit paths
;;       (let* ((jit-prefix (string-trim
;;                           (shell-command-to-string
;;                            (concat brew-bin " --prefix libgccjit"))))
;;              (jit-lib-current (expand-file-name "lib/gcc/current" jit-prefix)))
;;         (push jit-lib-current paths)))

;;     (nreverse paths)))

;; (defun setup-macos-native-comp-library-paths ()
;;   "Set up LIBRARY_PATH for native compilation on macOS.
;; Includes Homebrew GCC paths and CommandLineTools SDK libraries."
;;   (let* ((existing-paths (split-string (or (getenv "LIBRARY_PATH") "") ":" t))
;;          (gcc-paths (homebrew-gcc-paths))
;;          (clt-paths '("/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"))
;;          (unique-paths (delete-dups
;;                         (append existing-paths gcc-paths clt-paths))))

;;     (setenv "LIBRARY_PATH" (mapconcat #'identity unique-paths ":"))))

;; ;; Set up library paths for native compilation on macOS.
;; (when (eq system-type 'darwin)
;;   (setup-macos-native-comp-library-paths))

(advice-add 'display-startup-echo-area-message :override #'ignore)

;; emacs-lsp-booster
;; https://github.com/blahgeek/emacs-lsp-booster
(setenv "LSP_USE_PLISTS" "true")
