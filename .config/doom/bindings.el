;;; bindings.el -*- lexical-binding: t; -*-

(defun vterm-vsplit () (interactive) (split-window-horizontally) (other-window 1) (+vterm/here default-directory))
(map! :leader "o v" #'vterm-vsplit)
(map! :leader "d" #'+workspace/close-window-or-workspace)
(map! :leader "f o" #'consult-recent-file)
(map! "C-/" #'comment-dwim)
(map! :leader "f O" #'find-file-other-window)
(defun ak/goto-todo () (interactive) (find-file (+org-capture-todo-file)))
(map! :leader "f t" #'ak/goto-todo)
(map! :leader "f g" #'consult-ripgrep)
(map! :leader "f G" #'consult-git-grep)
(map! :leader "O" #'projectile-find-file-other-window)
(map! :m "C-w b" #'split-window-vertically)
;; (map :leader "j k" '(lambda ()
;; ()
;;                       ))
(defvar ak/jupyter-buffer-name "*jupyter*")
(defvar ak/jupyter-dir "~/jupyter")
(defvar ak/jupyter-cmd "mj"); alias for setting up jupyter server
(defvar ak/jupyter-post-cleanup-cmd "mda"); alias for setting up jupyter server
(defvar ak/jupyter-url-or-port "8888"); alias for setting up jupyter server
(defun ak/start-jupyter ()
  (interactive)
  (if (get-buffer ak/jupyter-buffer-name) (switch-to-buffer (get-buffer ak/jupyter-buffer-name)) ; todo regexp or similar to determine if started
    (progn
                (save-window-excursion
                (cd ak/jupyter-dir)
                (vterm ak/jupyter-buffer-name)
                (vterm-send-string ak/jupyter-cmd)
                (vterm-send-return)
                )
                (sleep-for 0.8)
                (ein:login ak/jupyter-url-or-port #'(lambda (buffer url-or-port) (switch-to-buffer buffer)))
                )))
(map! :leader "j s" #'ak/start-jupyter)
(defun ak/kill-jupyter ()
(interactive)
(when (get-buffer ak/jupyter-buffer-name)
(save-window-excursion
  (ein:stop nil ak/jupyter-url-or-port) ; is this working?
  (switch-to-buffer (get-buffer ak/jupyter-buffer-name))
;;(interrupt-process)
(vterm-send-key "c" nil nil t)
(vterm-send "y")
(vterm-send-return)
(vterm-send-string ak/jupyter-post-cleanup-cmd)
(vterm-send-return)
(vterm-send-string "exit")
(vterm-send-return)
(kill-matching-buffers ".*ein.*" nil t)
)))
(map! :leader "j k" #'ak/kill-jupyter)

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))
