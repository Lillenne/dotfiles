;;; init.el -*- lexical-binding: t; -*-

(setq gc-cons-threshold 100000000) ; increase gc threshold to improve performance

(defvar ak/use-company t)
(when ak/use-company (load! "company.el"))

(defvar ak/use-mu4e nil)
(when ak/use-mu4e (load! "mu4e.el"))
(defvar ak/use-lsp-mode t)
(when ak/use-lsp-mode (load! "debug.el"))

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

(require 'evil-owl)
(setq evil-owl-max-string-length 500)
(add-to-list 'display-buffer-alist
             '("*evil-owl*"
               (display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.3)))
(evil-owl-mode)

(use-package evil-snipe
  :config
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  (setq evil-snipe-use-vim-sneak-bindings t)
  (setq evil-snipe-scope 'buffer)
  (setq evil-snipe-auto-scroll t)
  (setq evil-snipe-use-vim-sneak-bindings t))

(use-package evil-quickscope
  :config (global-evil-quickscope-always-mode 1))


(setq org-link-descriptive nil)

(evil-visual-mark-mode)

(require 'evil-replace-with-register)
;; change default key bindings (if you want) HERE
;; (setq evil-replace-with-register-key (kbd "gr"))
(evil-replace-with-register-install)

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
