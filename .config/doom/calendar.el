;;; calendar.el -*- lexical-binding: t; -*-

(setq diary-file "~/diary")
(defvar ak/work-cal-ics (getenv "WORK_CALENDAR"))
(defvar ak/personal-cal-ics (getenv "PERSONAL_CALENDAR"))
; todo automatically sync calendar? daily?

; todo adjust org-timeblock-mode-map, interactions with evil mode
(map! :leader "o s" #'org-timeblock)
(map! :leader "o S" #'org-timeblock-quit)

(require 'calfw-cal)
(require 'calfw-ical)
(require 'calfw-org)

(defun ak/calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; orgmode source
    (cfw:ical-create-source "Work" ak/work-cal-ics "Gray")
    (cfw:ical-create-source "Personal" ak/personal-cal-ics "IndianRed")
   )))
(map! :leader "o C" #'ak/calendar)
