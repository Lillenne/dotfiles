;;; polish.el -*- lexical-binding: t; -*-


(require 'corfu)
(setq corfu-popupinfo-delay '(0.1 . 0.3))
(setq-default org-hide-leading-stars nil)

;; Name and email
(setq user-full-name (getenv "NAME"))
(load! "mu4e.el")

;; Calendar / Org
(require 'org)
;; (load! "calendar.el")

;; Todoist
(require 'org-todoist)
(setq org-todoist-api-token (getenv "TODOIST_TOKEN"))
(when (string= (s-trim (shell-command-to-string "hostname")) "dark")
  (defvar ak/todoist-timer (run-at-time 30 900 #'org-todoist-background-sync)))
