;;; calendar.el -*- lexical-binding: t; -*-

(setq diary-file "/home/aus/diary")
(defvar ak/calendar-cache "~/.cache/calendar-cache/")
(require 'f)
(if (not (f-exists-p ak/calendar-cache)) (mkdir ak/calendar-cache))
(defvar ak/calendar-cache-update-time (concat (file-name-as-directory (expand-file-name ak/calendar-cache)) "update-time"))
(defun ak/calendar-cache-update-time () (unless (not (f-exists-p ak/calendar-cache-update-time)) (string-to-number (f-read-text ak/calendar-cache-update-time))))
(defun ak/calendar-cache-clear () (interactive) (delete-file ak/calendar-cache-update-time) (cfw:ical-data-cache-clear-all))
(defvar ak/work-cal-ics (getenv "WORK_CALENDAR"))
(defvar ak/personal-cal-ics (getenv "PERSONAL_CALENDAR"))
(defvar ak/calendar-cache-duration-secs 900)
(defun my/make-cal-path (input) (concat (file-name-as-directory ak/calendar-cache) input))
(setq icalendar-import-format-description "") ; parser fails on the description element for many teams meetings
(defun my/update-calendar ()
  (ignore-errors
  (unless (or (null ak/calendar-cache-update-time)
           (< (- (float-time) (if (ak/calendar-cache-update-time) (ak/calendar-cache-update-time) 0)) ak/calendar-cache-duration-secs ))
    (cfw:ical-data-cache-clear-all)
    (if (not (f-exists-p ak/calendar-cache)) (mkdir ak/calendar-cache))
    (if (f-exists-p diary-file)
        (delete-file diary-file)
        (make-empty-file diary-file))
    (defun my/import (url name)
      (let ((path (my/make-cal-path name)))
        (if (f-exists-p path)
            (delete-file path))
        (url-copy-file url path)
        (icalendar-import-file path diary-file) ; errors parsing work calendar diary sexp
        ))
    (f-write-text (number-to-string (float-time)) 'utf-8 ak/calendar-cache-update-time) ; vs current time string
    (my/import ak/work-cal-ics "work.ics")
    (my/import ak/personal-cal-ics "personal.ics")
    (kill-matching-buffers ".*ics" nil t)
    )
  ))
;; (defvar my/calendars '((getenv "WORK_CALENDAR") (getenv "PERSONAL_CALENDAR")))
    ;; (dolist (cur-cal my/calendars)
    ;;   (let (cache-path (my/make-cal-path cur-cal)))
    ;;     (url-copy-file cur-cal cache-path)
    ;;     (icalendar-import-file cache-path diary-file)
    ;;   )

(setq cfw:org-capture-template '("c" "calfw2org" entry (file+headline +org-capture-todo-file "Inbox") "* %? \nSCHEDULED: %(cfw:org-capture-day)"))
(require 'calfw-cal)
(require 'calfw-ical)
(require 'calfw-org)

(defun ak/calendar ()
  (interactive)
  (my/update-calendar)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; orgmode source
    (cfw:cal-create-source "Gray") ; diary source ;helpful since it shows recurring events. Must disable descriptions
    ;; (cfw:ical-create-source "Work" (my/make-cal-path "work.ics") "Gray")
    ;; (cfw:ical-create-source "Personal" (my/make-cal-path "personal.ics")"IndianRed")
   )))
(map! :leader "o C" #'ak/calendar)
