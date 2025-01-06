;;; todoist.el -*- lexical-binding: t; -*-

;; (require 'todoist)
;; (setq todoist-token (getenv "TODOIST_TOKEN"))
;; (map! :leader "T q" #'todoist-quick-new-task)
;; (map! :leader "T t" #'todoist)
;; (map! :leader "T T" #'todoist-task-menu)


;; (load! "/home/aus/projects/org-todoist/test.el")
(require 'org-todoist)
(setq org-todoist-api-token (getenv "TODOIST_TOKEN"))
