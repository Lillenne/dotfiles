;;; todoist.el -*- lexical-binding: t; -*-

;; (require 'todoist)
;; (setq todoist-token (getenv "TODOIST_TOKEN"))
;; (map! :leader "T q" #'todoist-quick-new-task)
;; (map! :leader "T t" #'todoist)
;; (map! :leader "T T" #'todoist-task-menu)


;; (load! "/home/aus/projects/org-todoist/test.el")
(require 'org-todoist)
(setq org-todoist-api-token (getenv "TODOIST_TOKEN"))
(setq org-todoist-storage-dir (expand-file-name "todoist-sync" org-directory))
(map! :leader "t q q" #'org-todoist-sync)
;; (map! :leader "t q r" #'org-todoist-reset)
(map! :leader "t q s" #'org-todoist-assign-task)
(map! :leader "t q u" #'org-todoist-unassign-task)
(map! :leader "t q @" #'org-todoist-tag-user)
(setq org-todoist-show-n-levels -1)
