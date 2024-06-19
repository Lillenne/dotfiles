;;; calendar.el -*- lexical-binding: t; -*-

(require 'calfw-ical)
(defun ak/work-cal () (interactive) (cfw:open-ical-calendar ""))
(map! :leader "o C" #'ak/work-cal)
; todo automatically sync calendar? daily?

; todo adjust org-timeblock-mode-map
(map! :leader "o s" #'org-timeblock)
(map! :leader "o S" #'org-timeblock-quit)
