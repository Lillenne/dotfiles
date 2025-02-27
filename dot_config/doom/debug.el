;;; debug.el -*- lexical-binding: t; -*-

(setenv "LSP_USE_PLISTS" "true") ; remember to add this to /etc/environment or .config/emacs/early-init.el
(setq lsp-use-plists t) ; note, csharp-roslyn doesn't seem to work with this parameter
(setenv "DOTNET_ROOT" "/usr/share/dotnet/") ; arch path for dotnet. Is being overridden somewhere -- need to find
(global-docstr-mode 1)

;; Debugging
(with-eval-after-load 'dap-mode
  (setq dap-default-terminal-kind "integrated")
  (dap-auto-configure-mode +1))
(add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra)))
(setq dap-auto-configure-features '(sessions expressions locals controls tooltip))

;; C#
(require 'dap-netcore)
(setq dap-netcore-install-dir "/home/aus/.local/share/nvim/mason/packages/" )
(setq lsp-csharp-omnisharp-enable-decompilation-support t)

;; Rust
(require 'dap-gdb-lldb)
;;(with-eval-after-load 'lsp-rust (require 'dap-cpptools))
;; (dap-cpptools-setup) ; needs to be run only once
;; yay -S gdb
(dap-gdb-lldb-setup)
(dap-register-debug-template "Rust::GDB Run Configuration"
                             (list :type "gdb"
                                   :request "launch"
                                   :name "GDB::Run"
                                   :gdbpath "rust-gdb"
                                   :target nil
                                   :cwd nil))

;; someone's from the internet
;; (add-hook 'rustic-mode-hook (lambda ()
;;    (dap-register-debug-template "Rust LLDB Debug Configuration"
;; 	  (list :type "cppdbg"
;; 	      :request "launch"
;; 	      :name "Rust::Run"
;; 	      :MIMode "lldb"
;; 	      :gdbpath "rust-lldb"
;; 	      :program (concat (projectile-project-root) "target/debug/" (projectile-project-name)) ;; Requires that the rust project is a project in projectile
;; 	      :environment []
;; 	      :cwd (projectile-project-root)))))

;; Python
(require 'dap-python)
(setq dap-python-debugger 'debugpy)

;; LSP testing
(setq
 ;;lsp-enable-symbol-highlighting nil
 lsp-ui-doc-show-with-mouse nil
 lsp-ui-doc-include-signature t
 lsp-ui-doc-enable t
 lsp-ui-doc-delay 0.2
 lsp-signature-function #'lsp-signature-posframe
 ;; lsp-signature-doc-lines nil
 lsp-headerline-breadcrumb-enable t
 lsp-lens-enable nil
 lsp-modeline-code-actions-enable t
 lsp-modeline-diagnostics-enable t
 lsp-modeline-workspace-status-enable t
 lsp-signature-auto-activate '(:on-trigger-char :on-server-request :after-completion)
 )
(setq lsp-auto-execute-action nil)
(setq lsp-idle-delay 0.5)
(setq read-process-output-max 1048576) ;; <= cat /proc/sys/fs/pipe-max-size
(setq lsp-log-io nil)
(setq lsp-signature-cycle t)
(setq lsp-inlay-hint-enable t)

(setq lsp-rust-analyzer-discriminants-hints t)
;; (setq lsp-rust-analyzer-server-display-inlay-hints t)
(setq lsp-rust-analyzer-display-parameter-hints t)
;; (setq lsp-rust-analyzer-diagnostics-enable-experimental t)
(setq lsp-rust-analyzer-diagnostics-enable t)
(setq lsp-rust-analyzer-binding-mode-hints t)
(setq lsp-rust-analyzer-display-chaining-hints t)
(setq lsp-rust-analyzer-display-reborrow-hints t)
(map!
 :map rustic-mode-map
 :localleader "b p" #'rustic-cargo-add)

(with-eval-after-load 'lsp-mode (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

;; LSP booster
;; (defun lsp-booster--advice-json-parse (old-fn &rest args)
;;   "Try to parse bytecode instead of json."
;;   (or
;;    (when (equal (following-char) ?#)
;;      (let ((bytecode (read (current-buffer))))
;;        (when (byte-code-function-p bytecode)
;;          (funcall bytecode))))
;;    (apply old-fn args)))
;; (advice-add (if (progn (require 'json)
;;                        (fboundp 'json-parse-buffer))
;;                 'json-parse-buffer
;;               'json-read)
;;             :around
;;             #'lsp-booster--advice-json-parse)

;; (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
;;   "Prepend emacs-lsp-booster command to lsp CMD."
;;   (let ((orig-result (funcall old-fn cmd test?)))
;;     (if (and (not test?)                             ;; for check lsp-server-present?
;;              (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
;;              lsp-use-plists
;;              (not (functionp 'json-rpc-connection))  ;; native json-rpc
;;              (executable-find "emacs-lsp-booster"))
;;         (progn
;;           (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
;;             (setcar orig-result command-from-exec-path))
;;           (message "Using emacs-lsp-booster for %s!" orig-result)
;;           (cons "emacs-lsp-booster" orig-result))
;;       orig-result)))
;; (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

;; (map! :m "g e" #'flymake-goto-next-error)
;; (map! :m "g E" #'flymake-goto-previous-error)
;; (map! :m "] e" #'flymake-goto-next-error)
;; (map! :m "[ E" #'flymake-goto-previous-error)
;; (map! :m "g l" #'flymake-show-diagnostic)

(map! "<C-.>" #'lsp-execute-code-action)
;; (map! :leader "l a" #'lsp-execute-code-action)

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

                                        ;ein binding reference
;; Key             Binding
;; -------------------------------------------------------------------------------
;; C-<down>     ein:worksheet-goto-next-input-km
;; C-<up>               ein:worksheet-goto-prev-input-km
;; M-S-<return> ein:worksheet-execute-cell-and-insert-below-km
;; M-<down>     ein:worksheet-not-move-cell-down-km
;; M-<up>               ein:worksheet-not-move-cell-up-km

;; C-x C-s              ein:notebook-save-notebook-command-km
;; C-x C-w              ein:notebook-rename-command-km

;; M-RET                ein:worksheet-execute-cell-and-goto-next-km
;; M-,          ein:pytools-jump-back-command
;; M-.          ein:pytools-jump-to-source-command

;; C-c C-a              ein:worksheet-insert-cell-above-km
;; C-c C-b              ein:worksheet-insert-cell-below-km
;; C-c C-c              ein:worksheet-execute-cell-km
;; C-u C-c C-c                  ein:worksheet-execute-all-cells
;; C-c C-e              ein:worksheet-toggle-output-km
;; C-c C-f              ein:file-open-km
;; C-c C-k              ein:worksheet-kill-cell-km
;; C-c C-l              ein:worksheet-clear-output-km
;; C-c RET              ein:worksheet-merge-cell-km
;; C-c C-n              ein:worksheet-goto-next-input-km
;; C-c C-o              ein:notebook-open-km
;; C-c C-p              ein:worksheet-goto-prev-input-km
;; C-c C-q              ein:notebook-kill-kernel-then-close-command-km
;; C-c C-r              ein:notebook-reconnect-session-command-km
;; C-c C-s              ein:worksheet-split-cell-at-point-km
;; C-c C-t              ein:worksheet-toggle-cell-type-km
;; C-c C-u              ein:worksheet-change-cell-type-km
;; C-c C-v              ein:worksheet-set-output-visibility-all-km
;; C-c C-w              ein:worksheet-copy-cell-km
;; C-c C-y              ein:worksheet-yank-cell-km
;; C-c C-z              ein:notebook-kernel-interrupt-command-km
;; C-c C-S-l    ein:worksheet-clear-all-output-km
;; C-c C-#              ein:notebook-close-km
;; C-c C-$              ein:tb-show-km
;; C-c C-/              ein:notebook-scratchsheet-open-km
;; C-c C-;              ein:shared-output-show-code-cell-at-point-km
;; C-c <down>   ein:worksheet-move-cell-down-km
;; C-c <up>     ein:worksheet-move-cell-up-km

;; C-c C-x C-r  ein:notebook-restart-session-command-km

;; C-c M-w              ein:worksheet-copy-cell-km
