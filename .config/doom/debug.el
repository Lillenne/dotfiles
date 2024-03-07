;;; debug.el -*- lexical-binding: t; -*-


;(setenv "LSP_USE_PLISTS" "true") ; remember to add this to .config/emacs/early-init.el

;; Debugging
(add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra)))
(setq dap-auto-configure-features '(sessions expressions locals controls tooltip))

;; C#
(require 'dap-netcore)
;; (setq dap-netcore-install-dir "/home/aus/.local/share/nvim/mason/packages/" )

;; Rust
(require 'dap-gdb-lldb)
(dap-gdb-lldb-setup)
(dap-register-debug-template "Rust::GDB Run Configuration"
        (list :type "gdb"
                :request "launch"
                :name "GDB::Run"
        :gdbpath "rust-gdb"
                :target nil
                :cwd nil))

;; Python
(require 'dap-python)
(setq dap-python-debugger 'debugpy)

;; LSP testing
(setq lsp-auto-execute-action nil)
(setq lsp-idle-delay 0.15)
(setq read-process-output-max 1048576) ;; <= cat /proc/sys/fs/pipe-max-size
(setq lsp-log-io nil)
(setq lsp-signature-cycle t)
(setq lsp-inlay-hint-enable t)

(setq lsp-rust-analyzer-discriminants-hints t)
(setq lsp-rust-analyzer-server-display-inlay-hints t)
(setq lsp-rust-analyzer-display-parameter-hints t)
(setq lsp-rust-analyzer-diagnostics-enable-experimental t)
(setq lsp-rust-analyzer-diagnostics-enable t)
(setq lsp-rust-analyzer-binding-mode-hints t)
(setq lsp-rust-analyzer-display-chaining-hints t)
(setq lsp-rust-analyzer-display-reborrow-hints t)

;;(with-eval-after-load 'lsp-mode
  ;;(add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

(map! :leader "g e" #'next-error)
(map! :leader "g E" #'previous-error)

(map! :leader "d d" #'dap-debug)
(map! :leader "d k" #'dap-disconnect)
(map! :leader "d K" #'dap-delete-all-sessions)
(map! :leader "d t" #'dap-debug-edit-template)
(map! :leader "d r" #'dap-debug-recent)
(map! :leader "d R" #'dap-debug-restart)
(map! :leader "d b" #'dap-breakpoint-toggle)
(map! :leader "d l" #'dap-debug-last)
(map! :leader "d h" #'dap-hydra)
(map! :leader "d s" #'dap-ui-sessions)
(map! :leader "d S" #'dap-delete-session)
(map! :leader "d D" #'dap-breakpoint-delete-all)
(map! :leader "d c" #'dap-breakpoint-condition)
(map! :leader "d C" #'dap-breakpoint-hit-condition)
(map! :leader "d m" #'dap-breakpoint-log-message)
(map! :leader "d x" #'dap-ui-expressions-add)
(map! :leader "d X" #'dap-ui-expressions-remove)
(map! :leader "d e" #'dap-eval)
(map! :leader "d E" #'dap-eval-region)
(map! :leader "d p" #'dap-eval-thing-at-point)
