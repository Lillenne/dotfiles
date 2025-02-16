;;; init.el -*- lexical-binding: t; -*-

;;TODO check out grip mode +grip flag for md mode https://github.com/seagle0128/grip-mode
;; lsp-bridge looking in ~/.emacs.d for omnisharp instead of doom's
;; need to change keybindings to support lsp-bridge

(setq gc-cons-threshold 100000000) ; increase gc threshold to improve performance

(defvar ak/use-mu4e nil)
(when ak/use-mu4e (load! "mu4e.el"))
(defvar ak/use-lsp-mode t)
(when ak/use-lsp-mode (load! "debug.el")(load! "company.el"))

(defvar ak/use-lsp-bridge nil)
(when ak/use-lsp-bridge (load! "lsp-bridge.el"))

(defvar ak/use-ellama t)
(when ak/use-ellama (load! "ellama.el"))

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

;; ;; bind `function.inner`(function block without name and args) to `f` for use in things like `vif`, `yif`
;; (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))

;; ;; You can also bind multiple items and we will match the first one we can find
;; (define-key evil-outer-text-objects-map "a" (evil-textobj-tree-sitter-get-textobj ("conditional.outer" "loop.outer")))


(setq evil-snipe-scope 'whole-visible)
(setq evil-snipe-auto-scroll t)

(use-package evil-quickscope
  :config (global-evil-quickscope-always-mode 1))


(setq org-link-descriptive nil)

;; (evil-visual-mark-mode)

;; (require 'evil-replace-with-register)
;; ;; change default key bindings (if you want) HERE
;; ;; (setq evil-replace-with-register-key (kbd "gr"))
;; (evil-replace-with-register-install)
;;

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
  (elpy-enable))

;; if having trouble with treesitter language grammars, use treesit-install-language-grammar


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
