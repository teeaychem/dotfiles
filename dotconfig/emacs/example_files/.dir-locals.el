
((auto-mode-alist . (("\\.custom\\'" . mlir-mode)))
 (nil
  . ((llvm-tools-mlir-lsp-server-bin . "/path/to/build/bin/mlir-lsp-server")
     (llvm-tools-mlir-pdll-lsp-server-bin . "/path/to/build/bin/mlir-pdll-lsp-server")
     (llvm-tools-pdll-compilation-database . "/path/to/build/tools/mlir/tools/pdll/pdll_compile_commands.yml")
     (llvm-tools-tablegen-lsp-server-bin . "/path/to/build/bin/tblgen-lsp-server")
     (llvm-tools-tablegen-compilation-database . "/path/to/build/tablegen_compile_commands.yml")))
 (python-base-mode
  . ((eglot-workspace-configuration ;; https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
      . (:pylsp (:plugins (:jedi (:environment "./.venv/")
                           :jedi_completion (:include_params t
                                             :fuzzy t
                                             :include_params :json-false
                                             :include_class_objects :json-false
                                             :resolve_at_most 50)
                           :pylint (:enabled :json-false)
                           :mccabe
                           (:enabled :json-false)))))
     (pyvenv-workon . "./.venv/")
     (indent-tabs-mode . nil)))
 (rust-ts-mode
  .((eglot-workspace-configuration
     . (:rust-analyzer
        ( :procMacro ( :attributes (:enable t)
                       :enable t)
          :cargo ( :buildScripts (:enable t)
                   :features "all")
          :diagnostics ( :disabled ["unresolved-proc-macro"
                                    "unresolved-macro-call"]))))))


 )
