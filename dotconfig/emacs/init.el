;; -*- lexical-binding: t; -*-

;;; Code:

(require 'use-package)

(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (require 'elpaca-use-package))
(elpaca-wait)

;; Emacs 31 snapshots include compat; avoid installing/activating a second copy.
(when (locate-library "compat")
  (add-to-list 'elpaca-ignored-dependencies 'compat))

;; save custom things to separate file, and also load before doing anything else with packages as it contains a useful list
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

;; (package-initialize)

;; (when (not (file-directory-p (expand-file-name "elpa" user-emacs-directory)))
;;   (package-refresh-contents)
;;   (package-install-selected-packages))

;; (setq use-package-verbose nil)
;; (setq use-package-always-ensure t)

(setq vc-follow-symlinks t)

(defun my/load-literate-config (source target)
  "Load TARGET, tangling SOURCE when its content changes.
Keep the SHA-256 cache beside TARGET."
  (let* ((cache (concat target ".sha256"))
         (digest (with-temp-buffer
                   (insert-file-contents-literally source)
                   (secure-hash 'sha256 (current-buffer))))
         (cached-digest (when (file-exists-p cache)
                          (with-temp-buffer
                            (insert-file-contents-literally cache)
                            (buffer-string)))))
    (unless (and (file-exists-p target) (equal digest cached-digest))
      (require 'ob-tangle)
      (org-babel-tangle-file source target "emacs-lisp")
      (with-temp-file cache (insert digest)))
    (load target nil 'nomessage)))

(my/load-literate-config
 (expand-file-name "config.org" user-emacs-directory)
 (expand-file-name "config.el" user-emacs-directory))

;; Daemon mode starts its server after loading init.el.
(unless (daemonp)
  (require 'server)
  (unless (server-running-p) (server-start)))

;;; init.el ends here
