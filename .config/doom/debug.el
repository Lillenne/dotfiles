;;; debug.el -*- lexical-binding: t; -*-

;; Set up debugging for c#
;; Enabling only some features
;; (defvar my-cs-dbg nil)
;; (when (my-cs-dbg) (
;;         (require 'dap-netcore)
;;         (setq dap-auto-configure-mode t)
;;         (setq dap-netcore-install-dir "/home/aus/.local/share/nvim/mason/packages/" )

;;         ;; c/c++/objc/swift
;;                                                 ;(require 'dap-lldb) ; was this already working?
;;                  ))
;; (after! dap-mode (require 'dap-cpptools)) ;;need to run dap-cpptools-setup on first time ;; don't think this even needed to be run
;; dap keymaps
;; -*- lexical-binding: t -*-
;; https://github.com/emacs-lsp/dap-mode/blob/master/docs/page/how-to.md
;; (define-minor-mode +dap-running-session-mode
;;   "A mode for adding keybindings to running sessions" ;description
;;   :init-value nil ; init value
;;   :lighter nil ; ?
;;   ;; :keymap (let ((map (make-sparse-keymap)))
;;   ;;           (define-key map (
;;   ;;               ([f6] . 'dap-continue)
;;   ;;               ) map))
;;   (make-sparse-keymap)
;;   (evil-normalize-keymaps) ;; if you use evil, this is necessary to update the keymaps
  ;; (
  ;;       (kbd [f4] . 'dap-next)
  ;;       (map! [f5] 'dap-continue)
  ;;       (map! [f8] 'dap-step-in)
  ;;       (map! [f7] 'dap-step-out)
  ;;  )
  ;; The following code adds to the dap-terminated-hook
  ;; so that this minor mode will be deactivated when the debugger finishes
  ;; (when +dap-running-session-mode
  ;;   (let ((session-at-creation (dap--cur-active-session-or-die)))
  ;;     (add-hook 'dap-terminated-hook
  ;;               (lambda (session)
  ;;                 (when (eq session session-at-creation)
  ;;                   (+dap-running-session-mode -1)))))))

;; Activate this minor mode when dap is initialized
;; (add-hook 'dap-session-created-hook '+dap-running-session-mode)

;; Activate this minor mode when hitting a breakpoint in another file
;; (add-hook 'dap-stopped-hook '+dap-running-session-mode)

;; Activate this minor mode when stepping into code in another file
;; (add-hook 'dap-stack-frame-changed-hook (lambda (session)
;;                                           (when (dap--session-running session)
;;                                             (+dap-running-session-mode 1))))

                                        ; https://discourse.doomemacs.org/t/how-to-re-bind-keys/56
;; (map! [f4] 'dap-next)
;; (map! [f5] 'dap-debug)
;; (map! [f7] 'dap-step-out)
;; (map! [f8] 'dap-step-in)
;; (map! [f9] 'dap-breakpoint-toggle)

;; (map! :after +dap-running-session-mode
;;       :map +dap-running-session-mode-map
;;       [f6] #'dap-continue)
;;

;; end dap keymap
                                        ; https://www.reddit.com/r/DoomEmacs/comments/pe20mf/debugging_c_how_do_i_use_dap_mode_cant_find_any/

(setq lsp-inlay-hint-enable t)
(setq lsp-rust-analyzer-server-display-inlay-hints t)
(setq lsp-rust-analyzer-display-parameter-hints t)

;; LSP testing
(setq lsp-auto-execute-action nil)
(setq lsp-idle-delay 0.05)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-log-io nil) ; if set to true can cause a performance hit
(setq lsp-signature-cycle t)
(setq lsp-rust-analyzer-diagnostics-enable-experimental t)
(setq lsp-rust-analyzer-binding-mode-hints t)
(setq lsp-rust-analyzer-display-chaining-hints t)
(setq lsp-rust-analyzer-display-reborrow-hints t)
