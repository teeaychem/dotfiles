;;; llvm-tools.el --- LLVM and MLIR editing tools -*- lexical-binding: t; -*-

;;; Commentary:

;; MLIR completion and formatting, project-local IR extensions, and lit tests.
;; Install LLVM's Emacs modes separately.  Eglot completion and Dirvish preview
;; integrations are registered when those libraries load.

;;; Code:

(require 'cl-lib)
(require 'compile)
(require 'seq)
(require 'subr-x)

(defvar-local llvm-tools-mlir-opt-bin "mlir-opt"
  "MLIR optimizer executable for formatting this buffer or project.")

(defvar-local llvm-tools-lit-program "llvm-lit"
  "Project lit runner, preferably the build's generated llvm-lit.
Set an absolute executable path in .dir-locals.el when it is not on PATH.")

(defvar-local llvm-tools-lit-test-directory nil
  "Default lit suite directory for selection, remembered after each run.
Set this in .dir-locals.el to suggest a directory outside the project build.")

(defun llvm-tools-lit-select-test-directory (source-root)
  "Choose a configured suite for SOURCE-ROOT, defaulting to the last choice."
  (require 'project)
  (let* ((project (project-current nil source-root))
         (root (if project (project-root project) source-root))
         (build (expand-file-name "build" root))
         (configs (when (file-directory-p build)
                    (directory-files-recursively build (rx string-start "lit.site.cfg.py" string-end))))
         (directories (mapcar #'file-name-directory configs)))
    (completing-read "Lit test directory: "
                     (or directories (list source-root)) nil nil nil nil
                     (or llvm-tools-lit-test-directory (car directories) source-root))))

(defun llvm-tools-lit-test-current-file (&optional choose-config)
  "Save and run this lit test, displaying the input consumed by FileCheck.
Choose a test directory each time.  With a prefix, also choose a different runner."
  (interactive "P")
  (unless buffer-file-name
    (user-error "This buffer does not visit a test file"))
  (let* ((source-root (or (locate-dominating-file buffer-file-name "lit.cfg.py") (user-error "No source lit.cfg.py found for this test")))
         (runner (or (unless choose-config (executable-find llvm-tools-lit-program)) (read-file-name "Project lit runner: " nil nil t)))
         (test-directory (expand-file-name (llvm-tools-lit-select-test-directory source-root)))
         (test-path (expand-file-name (file-relative-name buffer-file-name source-root) test-directory)))
    (setq runner (expand-file-name runner))
    (setq-local llvm-tools-lit-program runner
                llvm-tools-lit-test-directory test-directory)
    (save-buffer)
    (compilation-start
     (mapconcat #'shell-quote-argument (list runner "-a" "-j" "1" "-D" "FileCheck=FileCheck --dump-input=always --dump-input-filter=all" test-path) " ")
     'compilation-mode
     (lambda (_mode) "*lit*"))))

(defun llvm-tools--fontify-lit-output ()
  "Highlight MLIR in lit compilation output."
  (when (equal (buffer-name) "*lit*")
    (require 'mlir-mode)
    (font-lock-add-keywords nil mlir-font-lock-keywords 'append)))

(add-hook 'compilation-mode-hook #'llvm-tools--fontify-lit-output)

(defvar-local llvm-tools-mlir-extra-extensions         nil                "Project-local file extensions that should use `mlir-mode'.")

(defvar-local llvm-tools-mlir-extra-extension-applying nil                "Non-nil while applying project-local `mlir-mode' extension rules.")

(put 'llvm-tools-mlir-opt-bin 'safe-local-variable #'stringp)

(put 'llvm-tools-mlir-extra-extensions 'safe-local-variable (lambda (value) (and (listp value) (seq-every-p #'stringp value))))

(defun llvm-tools-mlir-mode-for-extra-extension ()
  "Use `mlir-mode' for project-local IR extensions."
  (when-let* ((file buffer-file-name)
              (extensions llvm-tools-mlir-extra-extensions)
              (extension (file-name-extension file)))
    (when (and (not llvm-tools-mlir-extra-extension-applying) (not (derived-mode-p 'mlir-mode)) (member extension extensions))
      (let ((llvm-tools-mlir-extra-extension-applying t))
        (mlir-mode)))))

(add-hook 'hack-local-variables-hook #'llvm-tools-mlir-mode-for-extra-extension)

(defun llvm-tools-dirvish-apply-mlir-dir-locals ()
  "Apply safe project-local MLIR extension rules to a Dirvish preview."
  (when buffer-file-name
    (let ((enable-dir-local-variables t)
          (enable-local-variables :safe))
      (hack-dir-local-variables))
    (llvm-tools-mlir-mode-for-extra-extension)
    (when (derived-mode-p 'mlir-mode) (font-lock-ensure))))

(with-eval-after-load 'dirvish
  (add-hook 'dirvish-preview-setup-hook #'llvm-tools-dirvish-apply-mlir-dir-locals))

(define-derived-mode pdll-mode mlir-mode "PDLL")

(with-eval-after-load 'eglot
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (when-let* (((derived-mode-p 'mlir-mode)) (provider (eglot-server-capable :completionProvider))
                          ((listp provider))            (triggers (plist-get provider :triggerCharacters)))
		(setf (plist-get provider :triggerCharacters) (vconcat (remove " " (append triggers nil)))))))

  (defun llvm-tools-mlir-eglot-completion-at-point ()
    "Complete MLIR operation names after the final dot."
    (when-let* ((capf (eglot-completion-at-point)))
      (pcase-let ((`(,beg ,end ,table . ,props) capf))
	(let ((new-beg beg))
          (save-excursion (goto-char (point)) (when (search-backward "." beg t) (setq new-beg (1+ (point)))))
          `(,new-beg ,end ,table ,@props)))))

  (defun llvm-tools-mlir-eglot-capf-setup ()
    "Use MLIR-aware Eglot completion bounds in MLIR buffers."
    (when (derived-mode-p 'mlir-mode)
      (setq-local completion-at-point-functions (cons #'llvm-tools-mlir-eglot-completion-at-point (remove #'eglot-completion-at-point completion-at-point-functions)))))

  (add-hook 'eglot-managed-mode-hook #'llvm-tools-mlir-eglot-capf-setup)
  )

;; Preserve existing .dir-locals.el settings.
(dolist (alias '((my/mlir-opt-bin . llvm-tools-mlir-opt-bin)
                 (my/lit-program . llvm-tools-lit-program)
                 (my/lit-test-directory . llvm-tools-lit-test-directory)
                 (my/mlir-extra-extensions . llvm-tools-mlir-extra-extensions)))
  (defvaralias (car alias) (cdr alias))
  (put (car alias) 'safe-local-variable
       (get (cdr alias) 'safe-local-variable)))

(provide 'llvm-tools)
;;; llvm-tools.el ends here
