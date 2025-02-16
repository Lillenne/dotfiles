;;; init.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Austin Kearns"
      user-mail-address "austinkearns47@gmail.com")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Jetbrains Mono Nerd Font" :size 20))
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;;(setq doom-theme 'doom-dark+)
;;(setq doom-theme 'doom-monokai-spectrum)
;;(setq doom-theme 'doom-ayu-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-roam-directory "~/org/Roam/")
(org-roam-db-autosync-mode)
(setq find-file-visit-truename t)

;;start fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-director')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . nil)
   (python . t)
   (csharp . t)
   (mermaid . t)
   ))
(setq ob-mermaid-cli-path "/usr/local/bin/mmdc")

                                        ;(require 'org-journal)
(setq org-journal-dir "~/org/journal")
                                        ;set images in org mode inline
(setq org-startup-with-inline-images t)
;; mu4e config
(set-email-account! "austin"
                    '((mu4e-sent-folder       . "/[Gmail]/Sent Mail")
                      (mu4e-drafts-folder     . "/[Gmail]/Drafts")
                      (mu4e-trash-folder      . "/[Gmail]/Trash")
                      (mu4e-refile-folder     . "/[Gmail]/All Mail")
                      (smtpmail-smtp-user     . "austinkearns47@gmail.com")
                      (user-full-name . "Austin Kearns")
                      (mu4e-compose-signature . "---\nAustin Kearns"))
                    t)
(setq +mu4e-gmail-accounts '(("austinkearns47@gmail.com" . "/")))
;; don't need to run cleanup after indexing for gmail
(setq mu4e-index-cleanup nil
      ;; because gmail uses labels as folders we can use lazy check since
      ;; messages don't really "move"
      mu4e-index-lazy-check t)
(setq mu4e-maildir-shortcuts
      '(("/Inbox"             . ?i)
        ("/[Gmail]/Sent Mail" . ?s)
        ("/[Gmail]/Trash"     . ?t)
        ("/[Gmail]/Drafts"    . ?d)
        ("/[Gmail]/All Mail"  . ?a)))

(setq mu4e-change-filenames-when-moving t)
(setq mu4e-update-interval (* 3 60))
(setq mu4e-get-mail-command "mbsync -a")

;; ;; Add extensions
;; (use-package cape
;;   ;; Bind dedicated completion commands
;;   ;; Alternative prefix keys: C-c p, M-p, M-+, ...
;;   :bind (("C-c a p" . completion-at-point) ;; capf
;;          ("C-c a t" . complete-tag)        ;; etags
;;          ("C-c a d" . cape-dabbrev)        ;; or dabbrev-completion
;;          ("C-c a h" . cape-history)
;;          ("C-c a f" . cape-file)
;;          ("C-c a k" . cape-keyword)
;;          ("C-c a s" . cape-symbol)
;;          ("C-c a a" . cape-abbrev)
;;          ("C-c a l" . cape-line)
;;          ("C-c a w" . cape-dict)
;;          ("C-c a \\" . cape-tex)
;;          ("C-c a _" . cape-tex)
;;          ("C-c a ^" . cape-tex)
;;          ("C-c a &" . cape-sgml)
;;          ("C-c a r" . cape-rfc1345))
;;   :init
;;   ;; Add `completion-at-point-functions', used by `completion-at-point'.
;;   ;; NOTE: The order matters!
;;   (add-to-list 'completion-at-point-functions #'cape-dabbrev)
;;   (add-to-list 'completion-at-point-functions #'cape-file)
;;   (add-to-list 'completion-at-point-functions #'cape-elisp-block)

;;   ;;(add-to-list 'completion-at-point-functions #'cape-history)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-tex)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-dict)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-line)
;; )

;; LSP testing
(setq lsp-auto-execute-action nil)
(setq lsp-idle-delay 0.1)
;;(setq lsp-idle-delay 0.750)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-log-io nil) ; if set to true can cause a performance hit
(setq lsp-signature-cycle t)

(setq lsp-rust-analyzer-server-display-inlay-hints t)

(company-quickhelp-mode)
;;(setq company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend))
;;(setq company-selection-wrap-around t)
(setq company-minimum-prefix-length 1)
(setq company-idle-delay 0.1)
;;(setq company-require-match nil)
;;(setq company-require-match t)

  ;;; Prevent suggestions from being triggered automatically. In particular,
  ;;; this makes it so that:
  ;;; - TAB will always complete the current selection.
  ;;; - RET will only complete the current selection if the user has explicitly
  ;;;   interacted with Company.
  ;;; - SPC will never complete the current selection.
  ;;;
  ;;; Based on:
  ;;; - https://github.com/company-mode/company-mode/issues/530#issuecomment-226566961
  ;;; - https://emacs.stackexchange.com/a/13290/12534
  ;;; - http://stackoverflow.com/a/22863701/3538165
  ;;;
  ;;; See also:
  ;;; - https://emacs.stackexchange.com/a/24800/12534
  ;;; - https://emacs.stackexchange.com/q/27459/12534

;; Here we are using an advanced feature of define-key that lets
;; us pass an "extended menu item" instead of an interactive
;; function. Doing this allows RET to regain its usual
;; functionality when the user has not explicitly interacted with
;; Company.

;; <return> is for windowed Emacs; RET is for terminal Emacs
;; (dolist (key '("<return>" "RET"))
;;   (define-key company-active-map (kbd key)
;;     `(menu-item nil company-complete
;;                 :filter ,(lambda (cmd)
;;                            (when (company-explicit-action-p)
;;                              cmd)))))
;;(define-key company-active-map (kbd "TAB") #'company-complete-selection)
;; (define-key company-mode-map (kbd "<tab>") 'company-complete)
;; (define-key company-active-map (kbd "SPC") nil)
;; (define-key company-active-map (kbd "SPC") nil)
;;(define-key company-active-map (kbd "RET") nil)
;;(define-key company-active-map (kbd "<return>") nil)

;; Company appears to override the above keymap based on company-auto-complete-chars.
;; Turning it off ensures we have full control.
;; (setq company-auto-complete-chars n
;; (eval-after-load 'company
;; (setq company-frontends
;;       '(company-pseudo-tooltip-unless-just-one-frontend
;;         company-preview-frontend
;;         company-echo-metadata-frontend))

;;;
(with-eval-after-load 'company
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "<backtab>") #'company-quickhelp-manual-begin)
;;;  (setq company-require-match 'never)
  )

;; Do i want this off?
;;(setq electric-pair-open-newline-between-pairs t)

;; (defun electric-pair-brace-fixup ()
;;   (when (and electric-pair-mode
;;              (if (functionp electric-pair-open-newline-between-pairs)
;;                  (funcall electric-pair-open-newline-between-pairs)
;;                electric-pair-open-newline-between-pairs)
;;              (eq last-command-event ?\{)
;;              (= ?\{ (char-before)) (= ?\} (char-after)))
;;     (newline nil t)))

;; (advice-add 'electric-pair-post-self-insert-function :after
;;             #'electric-pair-brace-fixup)

(map! :leader "f o" 'consult-recent-file)
(map! "C-/" 'comment-dwim)
                                        ;(map! "C-M-/" 'comment-region)
                                        ; (map! :leader "o j c" 'org-journal-current-entry)
                                        ; (map! :leader "o j p" 'org-journal-previous-entry)
                                        ; (map! :leader "o j t" 'org-journal-next-entry)
(map! :leader "f O" 'find-file-other-window)
                                        ;(map! :leader "c m" 'markdown-other-window)


;; Set up debugging for c#
;; Enabling only some features
(require 'dap-netcore)
(setq dap-auto-configure-mode t)
(setq dap-netcore-install-dir "/home/aus/.local/share/nvim/mason/packages/" )

;; c/c++/objc/swift
                                        ;(require 'dap-lldb) ; was this already working?
(after! dap-mode (require 'dap-cpptools)) ;;need to run dap-cpptools-setup on first time ;; don't think this even needed to be run

;; dap keymaps
;; -*- lexical-binding: t -*-
;; https://github.com/emacs-lsp/dap-mode/blob/master/docs/page/how-to.md
(define-minor-mode +dap-running-session-mode
  "A mode for adding keybindings to running sessions" ;description
  :init-value nil ; init value
  :lighter nil ; ?
  ;; :keymap (let ((map (make-sparse-keymap)))
  ;;           (define-key map (
  ;;               ([f6] . 'dap-continue)
  ;;               ) map))
  (make-sparse-keymap)
  (evil-normalize-keymaps) ;; if you use evil, this is necessary to update the keymaps
  ;; (
  ;;       (kbd [f4] . 'dap-next)
  ;;       (map! [f5] 'dap-continue)
  ;;       (map! [f8] 'dap-step-in)
  ;;       (map! [f7] 'dap-step-out)
  ;;  )
  ;; The following code adds to the dap-terminated-hook
  ;; so that this minor mode will be deactivated when the debugger finishes
  (when +dap-running-session-mode
    (let ((session-at-creation (dap--cur-active-session-or-die)))
      (add-hook 'dap-terminated-hook
                (lambda (session)
                  (when (eq session session-at-creation)
                    (+dap-running-session-mode -1)))))))

;; Activate this minor mode when dap is initialized
(add-hook 'dap-session-created-hook '+dap-running-session-mode)

;; Activate this minor mode when hitting a breakpoint in another file
(add-hook 'dap-stopped-hook '+dap-running-session-mode)

;; Activate this minor mode when stepping into code in another file
(add-hook 'dap-stack-frame-changed-hook (lambda (session)
                                          (when (dap--session-running session)
                                            (+dap-running-session-mode 1))))

                                        ; https://discourse.doomemacs.org/t/how-to-re-bind-keys/56
(map! [f4] 'dap-next)
(map! [f5] 'dap-debug)
(map! [f7] 'dap-step-out)
(map! [f8] 'dap-step-in)
(map! [f9] 'dap-breakpoint-toggle)
;; (map! :after +dap-running-session-mode
;;       :map +dap-running-session-mode-map
;;       [f6] #'dap-continue)
;;

;; end dap keymap
                                        ; https://www.reddit.com/r/DoomEmacs/comments/pe20mf/debugging_c_how_do_i_use_dap_mode_cant_find_any/




;; Left for posterity / to remember how to add functions
;; (defun Myjfunc ()
;;   (interactive)
;;              (setq-local completion-at-point-functions
;;                  (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point))))
;;

(setq org-log-done 'time)

(setq org-roam-v2-ack t)

;; (require 'web-mode)
;; (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.razor?\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.cshtml?\\'" . web-mode))
;; (setq web-mode-engines-alist
;;       '(
;;         ("razor"    . "\\.cshtml\\'")
;;         ("razor"    . "\\.razor\\'")
;;         ("blade"  . "\\.blade\\.")
;;         )
;;       )

(defun vterm-vsplit () (interactive)
       (split-window-horizontally)
       (other-window 1)
       (+vterm/here default-directory))

(map! :leader "o v" 'vterm-vsplit)

(map! :leader "d" '+workspace/close-window-or-workspace)
                                        ; sp w c-s-jhkl - move windows around
                                        ; See full list for rust analyzer @ https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#lsp-rust-analyzer-display-parameter-hints
(setq lsp-inlay-hint-enable t)
(setq lsp-rust-analyzer-server-display-inlay-hints t)
(setq lsp-rust-analyzer-display-parameter-hints t)


(setq evil-owl-max-string-length 500)
(add-to-list 'display-buffer-alist
             '("*evil-owl*"
               (display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.3)))
(evil-owl-mode)

(evil-snipe-mode +1)
(evil-snipe-override-mode +1)
(setq evil-snipe-scope 'buffer)
(setq evil-snipe-auto-scroll t)
(setq evil-snipe-use-vim-sneak-bindings t)

(global-evil-quickscope-always-mode 1)
