;;; lsp-bridge.el -*- lexical-binding: t; -*-

;; lsp-bridge looking in ~/.emacs.d for omnisharp instead of doom's
;; need to change keybindings to support lsp-bridge
; Install dependencies prior to use:
; yay -S python-epc python-orjson python-sexpdata python-six python-setuptools python-paramiko python-rapidfuzz
; pip3 install epc orjson sexpdata six setuptools paramiko rapidfuzz
; Install Elisp dependencies: markdown-mode, yasnippet
; git clone https://github.com/manateelazycat/lsp-bridge.git ~/lsp-bridge
; disable lsp-mode + company from init.el
; See related statements in packages.el
; run lsp-bridge-install-omnisharp for c#. Can do similar for codeium, etc.
; Will then need to extract and give execute permissions: https://github.com/OmniSharp/omnisharp-roslyn/releases
; tar -xzf /tmp/omnisharp-mono.zip
; update .config/emacs/.local/straight/repos/lsp-bridge/langserver/omnisharp-dotnet.json & change omnisharp location

(use-package! lsp-bridge
  :config
  (setq lsp-bridge-enable-log nil)
  (global-lsp-bridge-mode)
  (define-key acm-mode-map (kbd "<tab>") #'acm-complete)
  (define-key acm-mode-map (kbd "<backtab>") #'acm-insert-common)
  (define-key evil-insert-state-map (kbd "C-k") nil)
  (define-key evil-insert-state-map (kbd "C-j") nil);; C-j is electric newline in evil insert map apparently
  (define-key acm-mode-map (kbd "C-j") #'acm-select-next)
  (define-key acm-mode-map (kbd "C-k") #'acm-select-prev)
  (define-key acm-mode-map (kbd "C-<down>") #'acm-doc-scroll-up)
  (define-key acm-mode-map (kbd "C-<up>") #'acm-doc-scroll-down)
  (define-key acm-mode-map (kbd "C-g") #'acm-hide)
  (define-key evil-normal-state-map (kbd "g d") #'lsp-bridge-find-def)
  (define-key evil-normal-state-map (kbd "g D") #'lsp-bridge-find-def-other-window)
  (define-key evil-normal-state-map (kbd "g b") #'lsp-bridge-find-def-return) ;; "no bride mark set"
  (define-key evil-normal-state-map (kbd "g i") #'lsp-bridge-find-impl)
  (define-key evil-normal-state-map (kbd "g I") #'lsp-bridge-find-impl-other-window)
  (define-key evil-normal-state-map (kbd "g .") #'lsp-bridge-show-documentation)
  (define-key evil-normal-state-map (kbd "g ,") #'lsp-bridge-popup-documentation)
  (global-set-key (kbd "C-<down>") nil) ; remove set-mark-command
  (global-set-key (kbd "C-<up>") nil) ; remove set-mark-command
  (define-key evil-normal-state-map (kbd "SPC R") #'lsp-bridge-rename)
  (define-key evil-normal-state-map (kbd "C-<up>") #'lsp-bridge-popup-documentation-scroll-down)
  (define-key evil-normal-state-map (kbd "C-<down>") #'lsp-bridge-popup-documentation-scroll-up)
  (define-key evil-normal-state-map (kbd "g e") #'lsp-bridge-diagnostic-jump-next)
  (define-key evil-normal-state-map (kbd "g E") #'lsp-bridge-diagnostic-jump-prev)
  (define-key evil-normal-state-map (kbd "g y") #'lsp-bridge-diagnostic-copy)
  (define-key evil-normal-state-map (kbd "C-.") #'lsp-bridge-code-action)
  (define-key evil-normal-state-map (kbd "M-<RET>") #'lsp-bridge-code-action)
  (define-key evil-normal-state-map (kbd "SPC c a") #'lsp-bridge-code-action)
  (define-key evil-insert-state-map (kbd "C-SPC") nil)
  ;; signature help still not working
  (global-set-key (kbd "C-SPC") #'lsp-bridge-signature-help-fetch) ; remove set-mark-command
  (define-key evil-insert-state-map (kbd "C-SPC") #'lsp-bridge-signature-help-fetch)
  (setq lsp-bridge-enable-with-tramp t)
  (setq lsp-bridge-enable-auto-format-code nil)
  (setq lsp-bridge-enable-hover-diagnostic t)
  (setq lsp-bridge-inlay-hint-overlays t)
  ;; (lsp-bridge-semantic-tokens-mode) ; what does this do?
  (setq lsp-bridge-enable-search-words nil)
  ;; (setq lsp-bridge-enable-debug nil)
  (setq lsp-bridge-enable-org-babel t)
  (setq lsp-bridge-find-def-fallback-function #'+lookup/definition)
  (setq acme-enable-doc t)
  ;(lsp-bridge-signature-show-with-frame "test_buf")
  (setq lsp-bridge-signature-show-with-frame-position "point")
  (setq acm-enable-search-file-words nil)
  (setq acm-enable-preview t) ;tabngo
  ;(setq lsp-bridge-semantic-tokens-delay 0.25)
  (setq lsp-bridge-code-action-preview-delay 0.35)
  (setq lsp-bridge-enable-signature-help t)
  (setq lsp-bridge-signature-help-fetch-idle 0.2)
  ;; (setq acme-enable-codeium nil)
  ;; (setq acme-enable-copilot nil)
  (setq acm-doc-frame-max-lines 35) ;; default 20
  (setq lsp-bridge-peek-file-content-height 15)
  (define-key evil-normal-state-map (kbd "<SPC> c p") #'lsp-bridge-peek)
  (define-key evil-normal-state-map (kbd "<SPC> c P") #'lsp-bridge-peek-abort)
  ;; (global-set-key ((kbd "SPC c k") #'lsp-bridge-peek-abort))
  )

;; more options for peek and indent avail
;; acm-enable-preview: enable Tab-and-Go completion, commands like acm-select-* will select and preview other candidate and further input will then commit this candidate, disable by default
