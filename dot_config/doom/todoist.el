;;; todoist.el -*- lexical-binding: t; -*-

(require 'org-todoist)
(setq org-todoist-storage-dir (expand-file-name "todoist-sync" org-directory))
(map! :leader "t q q" #'org-todoist-sync)
(map! :leader "t q r" #'org-todoist--reset)
(map! :leader "t q s" #'org-todoist-assign-task)
(map! :leader "t q u" #'org-todoist-unassign-task)
(map! :leader "t q @" #'org-todoist-tag-user)
(setq org-todoist-show-n-levels -1
      org-todoist-show-special nil)

(nconc org-capture-templates
       `(("s" "Todoist")
         ("sq" "Inbox" entry (file+olp ,(org-todoist-file) "Inbox" ,org-todoist--default-section-name) "* TODO %?")
         ("si" "Inbox" entry (file+olp ,(org-todoist-file) "Inbox" ,org-todoist--default-section-name) "* TODO %? %^G %^{EFFORT}p \nSCHEDULED: %^t")
         ("ss" "Select Project" entry (function org-todoist-find-project-and-section) "* TODO %^{What is the task} %^G %^{EFFORT}p %(org-todoist-assign-task) %(progn (org-schedule nil) nil) %(progn (org-deadline nil) nil)\n%?")
         ("sn" "Project Notes" entry (function org-todoist-project-notes) "* %?")))

(defun my/todoist-load-config ()
  (setq org-todoist-api-token (getenv "TODOIST_TOKEN"))
  (when my/is-main-pc
    (defvar ak/todoist-timer (run-at-time 30 900 #'org-todoist-background-sync))))
(add-hook 'my/config-loaded-hook #'my/todoist-load-config)

(defvar my/todo-only-files
  (append `(,(org-todoist-file)) (ak/from-org-dir-all "todo" "devenv" "learn"))
  "Org files to open with `org-show-todo-tree' active.")
(defun my/todo-only ()
  (when (member (buffer-file-name) my/todo-only-files)
    (org-show-todo-tree nil)))
(add-hook 'org-mode-hook #'my/todo-only 99)
