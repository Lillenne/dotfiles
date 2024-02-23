;;; org.el -*- lexical-binding: t; -*-

(setq org-directory "~/org/")
(setq org-roam-directory "~/org/")
(org-roam-db-autosync-mode)

;; note, need to create the headings before they are refiled properly
(defun ak/move-to-hold (heading &optional file)
        ;; Only refile if the target file is different than the current file
        (unless (equal (file-truename (expand-file-name (concat heading ".org") org-directory)) (file-truename (buffer-file-name)))
        (let ((fp (if (equal file nil) (expand-file-name "Tabled.org" org-directory) (expand-file-name file org-directory)))
                (org-refile-keep nil)
                (org-after-refile-insert-hook #'save-buffer))
                (org-refile nil nil (list heading fp nil (org-find-exact-headline-in-buffer heading (find-file-noselect fp) t))))))

(defun my/org-roam-copy-todo-to-today (&optional archive)
  (interactive)
  (let ((org-refile-keep t) ;; Set this to nil to delete the original!
        (org-roam-dailies-capture-templates
         '(("t" "tasks" entry "%?"
            :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
        (org-after-refile-insert-hook #'save-buffer)
        today-file
        pos)
    (save-window-excursion
      (org-roam-dailies--capture (current-time) t)
      (setq today-file (buffer-file-name))
      (setq pos (point)))

    ;; Only refile if the target file is different than the current file
    (unless (equal (file-truename today-file)
                   (file-truename (buffer-file-name)))
      (org-refile nil nil (list "Tasks" today-file nil pos)))
    (when archive (call-interactively #'org-archive-to-archive-sibling))
    ))

;;(setq org-after-todo-state-change-hook nil) ; enable for when testing config
(add-hook 'org-after-todo-state-change-hook
             (lambda ()
               (when (equal org-state "DONE") (my/org-roam-copy-todo-to-today t))
               (when (equal org-state "[X]") (my/org-roam-copy-todo-to-today))
               (when (equal org-state "HOLD") (ak/move-to-hold "Tabled"))
               (when (equal org-state "WAIT") (ak/move-to-hold "Wait"))
               (when (equal org-state "STRT") (ak/move-to-hold "Started" "in-progress.org"))
               ))
;; (add-to-list 'org-after-todo-state-change-hook
;;              (lambda ()
;;                (when (or (equal org-state "[X]") (equal org-state "DONE"))
;;                  (my/org-roam-copy-todo-to-today))))
;; Set depth to 95 (high, max 100), as it deletes the note & stuff shouldn't be coming after
;; (add-hook 'org-after-todo-state-change-hook
;;           (lambda ()
;;             (when (and (or (equal org-state "[X]") (equal org-state "DONE"))
;;                        (equal (+org-capture-todo-file) (buffer-file-name)))
;;                        (call-interactively #'org-archive-to-archive-sibling))
;;                        (save-buffer))
;;           95 nil)

;; replace the todo template
;; complete w/ rest of templates
(setq org-capture-templates (cons '("t" "Personal todo" entry (file+headline +org-capture-todo-file "Inbox") "* TODO %?\n%i\n%a" :prepend t)
                             (cons '("i" "Personal todo w/o link" entry (file+headline +org-capture-todo-file "Inbox") "* TODO %?" :prepend t)
                                (cdr org-capture-templates))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . nil)
   (python . t)
   (csharp . t)
   (shell . t)
   (bash . t)
   ;;(mermaid . t)
   ))
;;(setq ob-mermaid-cli-path "/usr/local/bin/mmdc")

(setq org-startup-with-inline-images t) ;set images in org mode inline
(setq org-log-done 'time)
(setq org-roam-v2-ack t)
(setq org-link-descriptive nil)

(defun ak/current-time-min-sec ()
  "Insert string for the current time formatted like '7:27 AM'."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%-I:%M %p")))
(map! :leader "i t" 'ak/current-time-min-sec)

(defun ak/today-time ()
  "Insert string for the current time formatted like '02/09/24 7:27 AM'."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%D %-I:%M %p")))
(map! :leader "i T" 'ak/today-time)

(defun ak/today-date ()
  "Insert string for today's date nicely formatted in American style,
e.g. Sunday, September 17, 2000."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%A, %B %e, %Y")))

(map! :leader "i d" 'ak/today-date)

(defun ak/today-date-time ()
  "Insert string for today's date nicely formatted in American style,
e.g. Friday, February  9, 2024 | 7:29 AM "
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%A, %B %e, %Y | %-I:%M %p")))

(map! :leader "i D" 'ak/today-date-time)

(setq org-roam-dailies-capture-templates '(("d" "default" entry "* %<%-I:%M %p>: %?" :target
  (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
