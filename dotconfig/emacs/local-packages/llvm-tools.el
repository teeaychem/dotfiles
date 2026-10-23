;;; llvm-tools.el --- LLVM and MLIR editing tools -*- lexical-binding: t; -*-

;;; Commentary:

;; Run lit tests, provide a PDLL mode, and construct Eglot server commands.
;; Set server paths and compilation databases with buffer or directory locals.
;; Explicit executable paths take precedence; PATH fallback is interactive only.
;; Install LLVM's Emacs modes separately.

;;; Code:

(require 'view)
(require 'rx)

(defgroup llvm-tools nil
  "Tools for working with LLVM projects."
  :group 'tools)

(defcustom llvm-tools-mlir-opt-bin "mlir-opt"
  "MLIR optimizer executable."
  :type 'string
  :safe #'stringp
  :group 'llvm-tools)

;; Keep existing project directory locals working.
(defvaralias 'my/mlir-lsp-server-bin 'llvm-tools-mlir-lsp-server-bin)
(defvaralias 'my/mlir-pdll-lsp-server-bin 'llvm-tools-mlir-pdll-lsp-server-bin)
(defvaralias 'my/pdll-compilation-database 'llvm-tools-pdll-compilation-database)
(defvaralias 'my/tablegen-lsp-server-bin 'llvm-tools-tablegen-lsp-server-bin)
(defvaralias 'my/tablegen-compilation-database 'llvm-tools-tablegen-compilation-database)

(defcustom llvm-tools-mlir-lsp-server-bin "mlir-lsp-server"
  "MLIR language server executable for this buffer or project."
  :type 'string
  :safe #'stringp
  :group 'llvm-tools)

(defcustom llvm-tools-mlir-pdll-lsp-server-bin nil
  "PDLL language server executable for this buffer or project."
  :type '(choice (const nil) file)
  :safe #'stringp
  :group 'llvm-tools)

(defcustom llvm-tools-pdll-compilation-database nil
  "PDLL compilation database for this buffer or project."
  :type '(choice (const nil) file)
  :safe #'stringp
  :group 'llvm-tools)

(defcustom llvm-tools-tablegen-lsp-server-bin nil
  "TableGen language server executable for this buffer or project."
  :type '(choice (const nil) file)
  :safe #'stringp
  :group 'llvm-tools)

(defcustom llvm-tools-tablegen-compilation-database nil
  "TableGen compilation database for this buffer or project."
  :type '(choice (const nil) file)
  :safe #'stringp
  :group 'llvm-tools)

;; Local-variable safety predicates belong to each alias as well as its target.
(dolist (variable '(my/mlir-lsp-server-bin
                    my/mlir-pdll-lsp-server-bin
                    my/pdll-compilation-database
                    my/tablegen-lsp-server-bin
                    my/tablegen-compilation-database))
  (put variable 'safe-local-variable #'stringp))

(defcustom llvm-tools-lit-program "llvm-lit"
  "Lit runner, preferably the build's generated llvm-lit."
  :type 'string
  :group 'llvm-tools)

(defcustom llvm-tools-lit-arguments
  '("-a"                         ; Show output for passing tests too.
    "-j" "1"                     ; Run one test at a time.
    "-D" "FileCheck=FileCheck --dump-input=always --dump-input-filter=all") ; Dump all FileCheck input.
  "Arguments passed to lit before the test path."
  :type '(repeat string)
  :group 'llvm-tools)

(dolist (variable '(llvm-tools-mlir-opt-bin
                    llvm-tools-lit-program
                    llvm-tools-lit-arguments
                    llvm-tools-mlir-lsp-server-bin
                    llvm-tools-mlir-pdll-lsp-server-bin
                    llvm-tools-pdll-compilation-database
                    llvm-tools-tablegen-lsp-server-bin
                    llvm-tools-tablegen-compilation-database))
  (make-variable-buffer-local variable))

(defun llvm-tools--file-executable-p (path)
  "Return non-nil when PATH names an executable file."
  (and (stringp path) (not (string= path "")) (file-executable-p path)))

(defun llvm-tools--file-readable-p (path)
  "Return non-nil when PATH names a readable file."
  (and (stringp path) (not (string= path "")) (file-readable-p path)))

(defun llvm-tools--lsp-server-path (setting path fallback interactive)
  "Return explicit PATH, or FALLBACK from `exec-path' when INTERACTIVE.
Signal a user error when neither names an executable.  SETTING names
the buffer-local option to report in the error."
  (cond
   ((llvm-tools--file-executable-p path) path)
   ((and interactive (executable-find fallback)))
   (t (user-error "Eglot aborted: %s is invalid (%s)" setting (or path "Unset")))))

(defun llvm-tools-eglot-mlir (&optional interactive _project)
  "Return the MLIR language-server command for the current buffer.
Only use PATH fallback when INTERACTIVE is non-nil."
  (list (llvm-tools--lsp-server-path
         'llvm-tools-mlir-lsp-server-bin llvm-tools-mlir-lsp-server-bin
         "mlir-lsp-server" interactive)))

(defun llvm-tools--eglot-database-command (language server-setting fallback database interactive)
  "Build an Eglot command for LANGUAGE with a readable DATABASE.
SERVER-SETTING names the buffer-local executable option.  Use FALLBACK
from PATH only when INTERACTIVE is non-nil.  LANGUAGE's lowercase name
selects the compilation database option."
  (let ((server-path (llvm-tools--lsp-server-path
                      server-setting (symbol-value server-setting)
                      fallback interactive)))
    (unless (llvm-tools--file-readable-p database)
      (user-error "Eglot aborted: %s compilation database setting is invalid (%s)"
                  language (or database "Unset")))
    (list server-path
          (format "--%s-compilation-database=%s" (downcase language) database))))

(defun llvm-tools-eglot-pdll (&optional interactive _project)
  "Return the PDLL language-server command for the current buffer.
Require a readable compilation database.  Only use PATH fallback when
INTERACTIVE is non-nil."
  (llvm-tools--eglot-database-command
   "PDLL" 'llvm-tools-mlir-pdll-lsp-server-bin "mlir-pdll-lsp-server"
   llvm-tools-pdll-compilation-database interactive))

(defun llvm-tools-eglot-tablegen (&optional interactive _project)
  "Return the TableGen language-server command for the current buffer.
Require a readable compilation database.  Only use PATH fallback when
INTERACTIVE is non-nil."
  (llvm-tools--eglot-database-command
   "TableGen" 'llvm-tools-tablegen-lsp-server-bin "tblgen-lsp-server"
   llvm-tools-tablegen-compilation-database interactive))

(define-error 'llvm-tools-lit-error "Cannot run lit" 'user-error)

(defvar-local llvm-tools-lit-last-suite-directory nil
  "Last selected configured lit suite directory.")

(defun llvm-tools-lit-select-test-directory (source-root)
  "Choose a configured suite for SOURCE-ROOT, defaulting to the last choice."
  (require 'project)
  (let* ((project (project-current nil source-root))
         (build (expand-file-name "build" (if project (project-root project) source-root)))
         (configs (when (file-directory-p build) (directory-files-recursively build (rx string-start "lit.site.cfg.py" string-end))))
         (directories (mapcar #'file-name-directory configs)))
    (completing-read "Lit test directory: "
                     (or directories (list source-root)) nil nil nil nil
                     (or llvm-tools-lit-last-suite-directory (car directories) source-root))))

(defun llvm-tools--lit-test-path (file)
  "Resolve FILE within the selected lit test suite."
  (let* ((source-root (or (locate-dominating-file file "lit.cfg.py")
                          (signal 'llvm-tools-lit-error '("No source lit.cfg.py found for this test"))))
         (test-directory (expand-file-name (llvm-tools-lit-select-test-directory source-root)))
         (test-path (expand-file-name (file-relative-name file source-root) test-directory)))
    (setq-local llvm-tools-lit-last-suite-directory test-directory)
    test-path))

(defun llvm-tools--lit-results-buffer (mode directory)
  "Prepare a lit results buffer using MODE in DIRECTORY.
Signal an error if the buffer already has a running process."
  (let ((buffer (get-buffer-create (format "*lit-%s*" mode))))
    (when (get-buffer-process buffer) (signal 'llvm-tools-lit-error (list (format "A lit run is already active in %s" (buffer-name buffer)))))
    (with-current-buffer buffer
      (let ((inhibit-read-only t)) (erase-buffer))
      (setq default-directory directory)
      (funcall mode)
      (view-mode 1))
    buffer))

(defun llvm-tools--lit-start-process (arguments buffer)
  "Start lit with ARGUMENTS, sending output to BUFFER.
Use a pipe and do not prompt about this process when exiting Emacs."
  (let ((process-connection-type nil))
    (let ((process (apply #'start-file-process "lit" buffer arguments)))
      (set-process-query-on-exit-flag process nil)
      process)))

(defun llvm-tools--lit-view-results (arguments mode)
  "Run lit with ARGUMENTS and display its output using MODE."
  (let ((buffer (llvm-tools--lit-results-buffer mode default-directory)))
    (llvm-tools--lit-start-process arguments buffer)
    (display-buffer buffer)
    buffer))

(defun llvm-tools-lit-test-current-file (&optional choose-runner)
  "Save and run this lit test using `llvm-tools-lit-arguments'.
Choose a test directory each time.  With a prefix, also choose a different runner."
  (interactive "P")
  (unless buffer-file-name
    (signal 'llvm-tools-lit-error '("This buffer does not visit a test file")))
  (let* ((test-path (llvm-tools--lit-test-path buffer-file-name))
         (runner (expand-file-name
                  (or (unless choose-runner (executable-find llvm-tools-lit-program))
                      (read-file-name "Project lit runner: " nil nil t))))
         (arguments (append (list runner) llvm-tools-lit-arguments (list test-path))))
    (setq-local llvm-tools-lit-program runner)
    (save-buffer)
    (llvm-tools--lit-view-results arguments major-mode)))

(define-derived-mode pdll-mode mlir-mode "PDLL")

(provide 'llvm-tools)
;;; llvm-tools.el ends here
