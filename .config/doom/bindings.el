;;; bindings.el -*- lexical-binding: t; -*-

(defun vterm-vsplit () (interactive) (split-window-horizontally) (other-window 1) (+vterm/here default-directory))
(map! :leader "o v" #'vterm-vsplit)
(map! :leader "k" #'+workspace/close-window-or-workspace)
(map! :leader "yy" #'ak/copy-full-path)
(map! :leader "YY" #'ak/copy-full-path-dired)
(map! :leader "Z" #'olivetti-mode)
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
(map! "C-w b" #'split-window-vertically)
(map! "C-h" #'evil-window-left)
(map! "C-l" #'evil-window-right)
(map! "C-k" #'evil-window-up)
(map! "C-S-r" #'evil-window-rotate-downwards)
(map! "C-M-r" #'evil-window-rotate-upwards)
(map! "|" #'split-window-right)
(map! "#" #'split-window-below)

(use-package evil-nerd-commenter
  :bind ("C-/" . evilnc-comment-or-uncomment-lines))

(map! :n  "C-a"   #'evil-numbers/inc-at-pt
      :v  "C-a"   #'evil-numbers/inc-at-pt-incremental
      :v  "C-S-a" #'evil-numbers/inc-at-pt
      :n  "C-x"   #'evil-numbers/dec-at-pt
      :v  "C-x"   #'evil-numbers/dec-at-pt-incremental)
