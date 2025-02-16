;;; org.el -*- lexical-binding: t; -*-

(setq org-directory "~/org/")
(setq org-roam-directory "~/org/roam")
(setq +org-capture-todo-file "~/org/todos.org")
(org-roam-db-autosync-mode)

;; fix for yasnippet tab key in org mode
(defun my/org-tab-conditional ()
  (interactive)
  (if (yas-active-snippets)
      (yas-next-field-or-maybe-expand)
    (org-cycle)))

(map! :after evil-org
      :map evil-org-mode-map
      :i "<tab>" #'my/org-tab-conditional)

;; note, need to create the headings before they are refiled properly
(defun ak/move-to-hold (heading &optional file)
        ;; Only refile if the target file is different than the current file
        (unless (equal (file-truename (expand-file-name (concat heading ".org") org-directory)) (file-truename (buffer-file-name)))
        (let ((fp (if (equal file nil) (expand-file-name "Tabled.org" org-directory) (expand-file-name file org-directory)))
                (org-refile-keep nil)
                (org-after-refile-insert-hook #'save-buffer))
                ;; (when (or (or (equal org-state "KILL") (equal org-state "HOLD")) (equal org-state "WAIT"))
                ;;   (org-add-note)) ;add note here because the refile otherwise goes first -- nvm still goes first, need to block on the note somehow. For now, just manually take a note first
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

;;;; doesn't always check the box
;; (defun ak/toggle-org-checkbox () (interactive)
;;        (let ((time (format "\nCLOSED: [%s]" (format-time-string "%Y-%m-%d %a %H:%M"))))
;;          (progn (org-toggle-checkbox) (end-of-line) (insert time))))
;; (add-hook 'org-mode-hook (lambda () (map! :leader "m x" #'ak/toggle-org-checkbox)))

(add-hook 'org-after-todo-state-change-hook
             (lambda ()
               (when (equal org-state "DONE") (my/org-roam-copy-todo-to-today t))
               (when (equal org-state "[X]") (my/org-roam-copy-todo-to-today))
               (when (equal org-state "HOLD") (ak/move-to-hold "Tabled"))
               (when (equal org-state "WAIT") (ak/move-to-hold "Wait"))
               (when (equal org-state "KILL") (ak/move-to-hold "Canceled"))
               ;; (when (equal org-state "STRT") (ak/move-to-hold "Started" "in-progress.org"))
               ) 100)

;how to do tags for meetings? make it a roam capture?

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . nil)
   (python . t)
   (csharp . t)
   (shell . t)
   (bash . t)
   (mermaid . t)
   ))
(setq ob-mermaid-cli-path "/usr/bin/mmdc")

; add @ to prompt a note + others
(setq org-todo-keywords
'((sequence "TODO(t)" "PROJ(p)" "LOOP(r)" "STRT(s)" "WAIT(w)" "HOLD(h)" "IDEA(i)" "|" "DONE(d)" "KILL(k)")
 (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
 (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")
 (sequence "LEARN(l)" "LEARNED(L)")))

(setq org-startup-with-inline-images t) ;set images in org mode inline
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-redeadline nil) ; Don't log the time a task was rescheduled or redeadlined.
(setq org-log-reschedule nil)
(setq org-roam-v2-ack t)
(setq org-link-descriptive nil)


(setq org-capture-templates
'(("n" "Personal notes" entry
(file+headline +org-capture-notes-file "Inbox")
"* %u %?\n%i\n%a" :prepend t)
("t" "Personal todo" entry (file+headline +org-capture-todo-file "Inbox") "* TODO %?\n%i\n%a" :prepend t)
("i" "Personal todo w/o link" entry (file+headline +org-capture-todo-file "Inbox") "* TODO %?" :prepend t)
("m" "Meetings")
("mm" "Scheduled Meeting" entry (file+olp+datetree "/home/aus/org/meetings.org")
        "* %^{What are we discussing?} %^G \nScheduled: %U\nFor: %^{When is the meeting?}t\n- Attendees: %^{Attendees}, Austin\n- Prep/Links: \n  - [ ] %?\n- Notes:"
        :target (file "meetings.org")
        :prepend t
        :clock-in t
        :clock-resume t
        :time-prompt t)
("mn" "Impromptu Meeting" entry (file+olp+datetree "/home/aus/org/meetings.org")
        "* %^{What are we discussing?} %^G \nScheduled: %U\nFor: %^{When is the meeting?}t\n- Attendees: %^{Attendees}, Austin\n To discuss \n - [ ] %?\n- Notes:"
        :target (file "meetings.org") :unnarrowed t
        :prepend t
        :clock-in t
        :clock-resume t
        :time-prompt t)
("j" "Journal" entry (file+olp+datetree +org-capture-journal-file) "* %U %?\n%i\n%a" :prepend t)
("p" "Templates for projects")
("pt" "Project-local todo" entry (file+headline +org-capture-project-todo-file "Inbox") "* TODO %?\n%i\n%a" :prepend t)
("pn" "Project-local notes" entry (file+headline +org-capture-project-notes-file "Inbox") "* %U %?\n%i\n%a" :prepend t)
("pc" "Project-local changelog" entry (file+headline +org-capture-project-changelog-file "Unreleased") "* %U %?\n%i\n%a" :prepend t)
;("c" "calfw2org" entry (file+headline +org-capture-todo-file "Inbox") "* %? \nSCHEDULED: %(cfw:org-capture-day)" :prepend t :time-prompt)
("c" "calfw2org" entry (file+headline +org-capture-todo-file "Inbox") "* %? \nSCHEDULED: %(cfw:org-capture-day)")
("o" "Centralized templates for projects")
("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t)))
(setq org-roam-dailies-capture-templates '(("d" "default" entry "* %<%-I:%M %p>: %?" :target
  (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))

(setq org-meetings-file "/home/aus/org/meetings.org")

;; not sure why this doesn't work with variables
(setq org-roam-capture-templates
'(
("i" "sprint-item" plain (file "/home/aus/org/roam/sprint-items/templates/template.org") :target (file "sprint-items/%<%Y%m%d%H%M%S>-${slug}.org") :unnarrowed t)
("s" "sprint" plain (file "/home/aus/org/roam/sprints/templates/template.org") :target (file "sprints/%<%Y%m%d%H%M%S>-${slug}.org") :unnarrowed t)
("d" "default" plain "%?" :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n") :unnarrowed t)
("m" "Meetings")
("mm" "Scheduled meeting" entry "* ${slug} %^G \nScheduled: %U\nFor: %^{When is the meeting?}T\n- Attendees: %^{Attendees}, Austin\n- Prep/Links: \n  - [ ] %?\n- Notes:"
        :target (file+datetree "meetings.org") :unnarrowed t :prepend t :clock-in t :clock-resume t :time-prompt t)
("mn" "Impromptu meeting" entry "* ${slug} %^G \n%T\n- Attendees: %^{Attendees}, Austin\n To discuss \n - [ ] %?\n- Notes:"
        :target (file+datetree "meetings.org"}) :unnarrowed t :prepend t :clock-in t :clock-resume t)
))

; add id to all captures
;; (add-hook 'org-capture-mode-hook #'org-id-get-create) ;https://www.reddit.com/r/orgmode/comments/eln9kb/capture_with_automatic_id_creation/

(require 'org-tempo) ;; This is needed as of Org 9.2
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("ru" . "src rust"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(set-company-backend! 'org-mode '(:separate company-org-block company-files company-dabbrev company-ispell) 'company-capf)
;; (defun org-babel-edit-prep:rust (babel-info)
;;   (setq-local buffer-file-name (->> babel-info caddr (alist-get :tangle)))
;;   (lsp))

(map! :leader "i b" #'tempo-template-org-src)

; todo org-protocol and org-roam-protocol

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

;; https://emacs.stackexchange.com/questions/72147/org-mode-adding-creation-date-property-upon-heading-creation
(add-hook 'org-insert-heading-hook
    (lambda()
    (save-excursion
              (org-back-to-heading)
              (org-set-property "CREATED" (format-time-string "[%Y-%m-%d %a %H:%M]")))))
