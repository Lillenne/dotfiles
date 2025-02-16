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

(setq org-gcal-client-id (getenv "GCAL_CLIENT_ID")
      org-gcal-client-secret (getenv "GCAL_CLIENT_SECRET")
      org-gcal-fetch-file-alist `((,(getenv "GMAIL") .  "~/org/calendar.org")
                                  (,(getenv "GCAL_WORK") .  "~/org/calendar_work.org")
                                  (,(getenv "GCAL_FAMILY") .  "~/org/calendar_family.org"))
      org-gcal-update-cancelled-events-with-todo t
      org-gcal-cancelled-todo-keyword "CANCELED"
      org-gcal-recurring-events-mode 'nested)
(require 'org-gcal)

;; Run ‘org-gcal-sync’ regularly not at startup, but at 8 AM every day,
;; starting the next time 8 AM arrives.
(run-at-time
 (let* ((now-decoded (decode-time))
        (today-8am-decoded
         (append '(0 0 8) (nthcdr 3 now-decoded)))
        (now (encode-time now-decoded))
        (today-8am (encode-time today-8am-decoded)))
   (if (time-less-p now today-8am)
       today-8am
     (time-add today-8am (* 24 60 60))))
 (* 24 60 60)
 (defun my-org-gcal-sync-clear-token ()
   "Sync calendar, clearing tokens first."
   (interactive)
   (require 'org-gcal)
   (when org-gcal--sync-lock
     (warn "%s" "‘my-org-gcal-sync-clear-token’: ‘org-gcal--sync-lock’ not nil - calling ‘org-gcal--sync-unlock’.")
     (org-gcal--sync-unlock))
   (org-gcal-sync-tokens-clear)
   (org-gcal-sync)
   nil))

(setq plstore-cache-passphrase-for-symmetric-encryption t)
(require 'plstore)
(map! :leader (:prefix ("t e" . "org-gcal")
                       "e" #'org-gcal-post-at-point
                       "d" #'org-gcal-delete-at-point
                       "s" #'org-gcal-sync))

;; (defun ak/org-gcal-remove-description (_calendar-id event _update-mode)
;;   "Removes the paragraph elements under the org gcal drawer.
;; Most of my meetings are Teams meetings that throw errors when parsing with cfw."
;;   (org-element-context)
;;   (when-let* ((stime (plist-get (plist-get event :start)
;;                                 :dateTime))
;;               (etime (plist-get (plist-get event :end)
;;                                 :dateTime))
;;               (diff (float-time
;;                      (time-subtract (org-gcal--parse-calendar-time-string etime)
;;                                     (org-gcal--parse-calendar-time-string stime))))
;;               (minutes (floor (/ diff 60))))
;;     (let ((effort (org-entry-get (point) org-effort-property)))
;;       (unless effort
;;         (message "need to set effort - minutes %S" minutes)
;;         (org-entry-put (point)
;;                        org-effort-property
;;                        (apply #'format "%d:%02d" (cl-floor minutes 60)))))))
;; (add-hook 'org-gcal-after-update-entry-functions #'my-org-gcal-set-effort)

;; (add-to-list 'plstore-encrypt-to '("GPG-key-id"))
;; https://github.com/kidd/org-gcal.el?tab=readme-ov-file#Installation
