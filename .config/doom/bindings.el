;;; bindings.el -*- lexical-binding: t; -*-

(defun vterm-vsplit () (interactive) (split-window-horizontally) (other-window 1) (+vterm/here default-directory))
(map! :leader "o v" #'vterm-vsplit)
(map! :leader "k" #'+workspace/close-window-or-workspace)
(map! :leader "yy" #'ak/copy-full-path)
(map! :leader "YY" #'ak/copy-full-path-dired)
(map! :leader "z" #'olivetti-mode)
(setq-default olivetti-body-width .4)
(map! :m "<C-S-up>" #'shrink-window)
(map! :m "<C-S-down>" #'enlarge-window)
(map! :m "<C-S-left>" #'shrink-window-horizontally)
(map! :m "<C-S-right>" #'enlarge-window-horizontally)

(map! :leader "f o" #'consult-recent-file)
;;(map! "C-/" #'comment-dwim) ; replaced by evil-nerd-commenter
(map! :leader "f O" #'find-file-other-window)
(defun ak/goto-todo () (interactive) (find-file (+org-capture-todo-file)))
(map! :leader "f t" #'ak/goto-todo)
(map! :leader "f w" #'consult-ripgrep)
(map! :leader "f f" #'consult-fd)
(map! :leader "f g" #'consult-git-grep)
(map! :leader "s g" #'consult-ripgrep)
(map! :leader "s G" #'consult-git-grep)
(map! :leader "O" #'projectile-find-file-other-window)
(map! :leader "w" #'save-buffer)
(map! :map 'override "C-w b" #'split-window-vertically)
(map! :map 'override "C-h" #'evil-window-left)
(map! :map 'override "C-l" #'evil-window-right)
(map! :map 'override "C-k" #'evil-window-up)
(map! :map 'override "C-j" #'evil-window-down)
(map! :map 'override "C-S-r" #'evil-window-rotate-downwards)
(map! :map 'override "C-M-r" #'evil-window-rotate-upwards)
(map! :map 'override "|" nil)
(map! :m "|" #'split-window-right)
(map! :m "#" #'split-window-below)
;; (map! :g "C-e" nil)
;; (map! :i "C-e" nil)
;; (map! :map 'override "C-e" #'corfu-quit)
;; (map! :map 'corfu-mode-map "C-e" #'corfu-quit)
;; (map! :map 'corfu-mode-map "C-g" nil)
;; (map! :map 'corfu-mode-map "TAB" nil)
;; (map! :map 'corfu-mode-map "[tab]" nil)
;; (map! :map 'corfu-mode-map "S-TAB" nil)
;; (map! :map 'corfu-mode-map "[backtab]" nil)

;; (map! :map 'corfu-map "C-e" #'corfu-quit)
;; (map! :map 'corfu-map "C-g" nil)
;; (map! :map 'corfu-map "TAB" nil)
;; (map! :map 'corfu-map "[tab]" nil)
;; (map! :map 'corfu-map "S-TAB" nil)
;; (map! :map 'corfu-map "[backtab]" nil)

(use-package evil-nerd-commenter
  :bind ("C-/" . evilnc-comment-or-uncomment-lines))

(map! :n  "C-a"   #'evil-numbers/inc-at-pt
      :v  "C-a"   #'evil-numbers/inc-at-pt-incremental
      :v  "C-S-a" #'evil-numbers/inc-at-pt
      :n  "C-x"   #'evil-numbers/dec-at-pt
      :v  "C-x"   #'evil-numbers/dec-at-pt-incremental)
