;;; init.el -*- lexical-binding: t; -*-

;;TODO check out grip mode +grip flag for md mode https://github.com/seagle0128/grip-mode
;; lsp-bridge looking in ~/.emacs.d for omnisharp instead of doom's
;; need to change keybindings to support lsp-bridge

;(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
;(setq fancy-splash-image "~/Downloads/Designcrop.png")
;(setq fancy-splash-image (concat doom-private-dir "~/Downloads/Design.png"))

(setq gc-cons-threshold 1000000) ; increase gc threshold to improve performance

(defvar ak/use-mu4e nil)
(when ak/use-mu4e (load! "mu4e.el"))
(defvar ak/use-lsp-mode t)
(when ak/use-lsp-mode (load! "debug.el")(load! "company.el"))

(defvar ak/use-lsp-bridge nil)
(when ak/use-lsp-bridge (load! "lsp-bridge.el"))

(defvar ak/use-ellama t)
(when ak/use-ellama (load! "ellama.el"))

(defun ak/is-minibuf () (minibuffer-window-active-p (current-buffer)))
(defun ak/is-only-window () (equal (length (window-list-1)) 1))
;; (add-hook 'dired-mode-hook #'olivetti-mode)
;; (add-hook 'minibuffer-mode-hook (lambda () (setq-local olivetti-body-width 0.2) (olivetti-mode)))

(load! "evil.el")
(load! "org.el")
(load! "bindings.el")

(setq user-full-name "Austin Kearns"
      user-mail-address "austinkearns47@gmail.com")

;;(setq doom-big-font (font-spec :family "Jetbrains Mono Nerd Font" :size 28))
;;(setq doom-unicode-font (font-spec :family "Jetbrains Mono Nerd Font" :size 28))
(setq doom-font (font-spec :family "Jetbrains Mono Nerd Font" :size 20))
(setq doom-theme 'doom-one)
(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;;start fullscreen

(setq display-line-numbers-type 'relative)
(setq find-file-visit-truename t)

(after! projectile
  (require 'f)
  (defun my-projectile-ignore-project (project-root)
    (or (f-descendant-of? project-root (expand-file-name "/home/aus/.rustup"))
        (f-descendant-of? project-root "/home/aus/.cargo")
        (doom-project-ignored-p project-root)))
  (setq projectile-ignored-project-function #'my-projectile-ignore-project)
  (add-to-list 'projectile-globally-ignored-file-suffixes ".onnx")
)

(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (setq elpy-autodoc-delay 0.3)
  (require 'pyvenv)
  (pyvenv-activate "/home/aus/micromamba/envs/ml/")
  (setq elpy-rpc-virtualenv-path 'current)
  (set-company-backend! 'elpy-mode 'elpy-company-backend)
  )

(defun ak/copy-full-path-dired () (interactive)
       (kill-new (expand-file-name (dired-copy-filename-as-kill))))
(defun ak/copy-full-path () (interactive)
       (kill-new (expand-file-name (buffer-file-name))))
(map! "C-M-Y" #'ak/copy-full-path)
(map! "C-S-Y" #'ak/copy-full-path-dired)
;; (after! dired (define-key dired-mode-map (kbd "C-S-y") #'ak/copy-full-path-dired))
;; (after! dired (add-hook 'dired-mode-hook (lambda () (local-set-key (kbd "C-y") #'ak/copy-full-path-dired))))


;; if having trouble with treesitter language grammars, use treesit-install-language-grammar

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
