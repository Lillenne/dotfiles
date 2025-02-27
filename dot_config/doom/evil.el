;;; evil.el -*- lexical-binding: t; -*-

(require 'evil-owl)
(setq evil-owl-max-string-length 500)
(add-to-list 'display-buffer-alist
             '("*evil-owl*"
               (display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.3)))
(evil-owl-mode)
(require 'evil-surround)
;; note for evil surround, to avoid adding a space with ([{ you must use the closing side }])
(global-evil-surround-mode +1)
(evil-surround-mode +1)
(evil-snipe-mode +1)
(evil-snipe-override-mode -1)
(setq evil-snipe-scope 'whole-buffer
      evil-snipe-auto-scroll t
      evil-snipe-smart-case t
      evil-snipe-auto-scroll t
      evil-snipe-use-vim-sneak-bindings t)
;; (use-package evil-quickscope
;;   :config (global-evil-quickscope-always-mode 1))

;; ;; bind `function.inner`(function block without name and args) to `f` for use in things like `vif`, `yif`
;; (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))

;; ;; You can also bind multiple items and we will match the first one we can find
;; (define-key evil-outer-text-objects-map "a" (evil-textobj-tree-sitter-get-textobj ("conditional.outer" "loop.outer")))

;; (evil-visual-mark-mode)

(require 'evil-replace-with-register)
;; change default key bindings (if you want) HERE
(setq evil-replace-with-register-key (kbd "gr"))
(evil-replace-with-register-install)
