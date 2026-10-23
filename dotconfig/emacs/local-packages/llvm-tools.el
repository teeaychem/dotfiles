;;; llvm-tools.el --- LLVM and MLIR editing tools -*- lexical-binding: t; -*-

;;; Commentary:

;; Run lit tests and provide a PDLL mode based on MLIR.
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
                    llvm-tools-lit-arguments))
  (make-variable-buffer-local variable))

(define-error 'llvm-tools-lit-error "Cannot run lit" 'user-error)

(defvar-local llvm-tools-lit-last-suite-directory nil
  "Last selected configured lit suite directory.")

(defun llvm-tools-lit-select-test-directory (source-root)
  "Choose a configured suite for SOURCE-ROOT, defaulting to the last choice."
  (require 'project)
  (let* ((project (project-current nil source-root))
         (build (expand-file-name "build" (if project (project-root project) source-root)))
         (configs (when (file-directory-p build)
                    (directory-files-recursively build (rx string-start "lit.site.cfg.py" string-end))))
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

(defun llvm-tools--lit-view-results (arguments mode)
  "Run lit with ARGUMENTS and display its output using MODE."
  (let ((buffer (get-buffer-create (format "*lit-%s*" mode)))
        (directory default-directory))
    (when (get-buffer-process buffer)
      (signal 'llvm-tools-lit-error
              (list (format "A lit run is already active in %s" (buffer-name buffer)))))
    (with-current-buffer buffer
      (let ((inhibit-read-only t)) (erase-buffer))
      (setq default-directory directory)
      (funcall mode)
      (view-mode 1))
    (let ((process-connection-type nil))
      (set-process-query-on-exit-flag
       (apply #'start-file-process "lit" buffer arguments) nil))
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
