;;; bindings.el -*- lexical-binding: t; -*-

(defun vterm-vsplit () (interactive) (split-window-horizontally) (other-window 1) (+vterm/here default-directory))
(map! :leader "o v" 'vterm-vsplit)
(map! :leader "o v" 'vterm-vsplit)
(map! :leader "d" '+workspace/close-window-or-workspace)
(map! :leader "f o" 'consult-recent-file)
(map! "C-/" 'comment-dwim)
(map! :leader "f O" 'find-file-other-window)
(defun ak/goto-todo () (interactive) (find-file (+org-capture-todo-file)))
(map! :leader "f t" 'ak/goto-todo)
(map! :leader "f g" 'consult-ripgrep)
(map! :leader "f G" 'consult-git-grep)

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))
