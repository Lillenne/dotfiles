;;; todoist.el -*- lexical-binding: t; -*-

(require 'org-todoist)
(setq org-todoist-storage-dir (expand-file-name "todoist-sync" org-directory))
;; org-todoist-file (expand-file-name "todoist.org" (expand-file-name "todoist-sync" org-directory)))
(map! :leader "t q q" #'org-todoist-sync)
;; (map! :leader "t q r" #'org-todoist-reset)
(map! :leader "t q s" #'org-todoist-assign-task)
(map! :leader "t q u" #'org-todoist-unassign-task)
(map! :leader "t q @" #'org-todoist-tag-user)
(setq org-todoist-show-n-levels -1)

(add-hook 'my/config-loaded-hook
          (lambda ()
            (setq org-todoist-api-token (getenv "TODOIST_TOKEN"))
            (when (string= (s-trim (shell-command-to-string "hostname")) "dark")
              (defvar ak/todoist-timer (run-at-time 30 900 #'org-todoist-background-sync)))))
