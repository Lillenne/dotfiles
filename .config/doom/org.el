;;; org.el -*- lexical-binding: t; -*-

;; https://emacs.stackexchange.com/questions/58875/how-do-i-add-appointments-to-effort-sum
(with-eval-after-load 'org-colview
  ;; adjusted org-agenda-columns function that now calls
  ;; org-agenda-columns--collect-values (see below) instead
  ;; of org-columns--collect-values
  (defun org-agenda-columns ()
    "Turn on or update column view in the agenda."
    (interactive)
    (org-columns-remove-overlays)
    (if (markerp org-columns-begin-marker)
        (move-marker org-columns-begin-marker (point))
      (setq org-columns-begin-marker (point-marker)))
    (let* ((org-columns--time (float-time))
           (fmt
            (cond
             ((bound-and-true-p org-overriding-columns-format))
             ((bound-and-true-p org-local-columns-format))
             ((bound-and-true-p org-columns-default-format-for-agenda))
             ((let ((m (org-get-at-bol 'org-hd-marker)))
                (and m
                     (or (org-entry-get m "COLUMNS" t)
                         (with-current-buffer (marker-buffer m)
                           org-columns-default-format)))))
             ((and (local-variable-p 'org-columns-current-fmt)
                   org-columns-current-fmt))
             ((let ((m (next-single-property-change (point-min) 'org-hd-marker)))
                (and m
                     (let ((m (get-text-property m 'org-hd-marker)))
                       (or (org-entry-get m "COLUMNS" t)
                           (with-current-buffer (marker-buffer m)
                             org-columns-default-format))))))
             (t org-columns-default-format)))
           (compiled-fmt (org-columns-compile-format fmt)))
      (setq org-columns-current-fmt fmt)
      (when org-agenda-columns-compute-summary-properties
        (org-agenda-colview-compute org-columns-current-fmt-compiled))
      (save-excursion
        ;; Collect properties for each headline in current view.
        (goto-char (point-min))
        (let (cache)
          (while (not (eobp))
            (let ((m (org-get-at-bol 'org-hd-marker)))
              (when m
                (push (cons (line-beginning-position)
                            ;; `org-columns-current-fmt-compiled' is
                            ;; initialized but only set locally to the
                            ;; agenda buffer.  Since current buffer is
                            ;; changing, we need to force the original
                            ;; compiled-fmt there.
                            ;; clavis
                            (org-agenda-columns--collect-values compiled-fmt m))
                      cache)))
            (forward-line))
          (when cache
            (org-columns--set-widths cache)
            (org-columns--display-here-title)
            (when (setq-local org-columns-flyspell-was-active
                              (bound-and-true-p flyspell-mode))
              (flyspell-mode 0))
            (dolist (entry cache)
              (goto-char (car entry))
              (org-columns--display-here (cdr entry)))
            (setq-local org-agenda-columns-active t)
            (when org-agenda-columns-show-summaries
              (org-agenda-colview-summarize cache)))))))

  ;; new function that substitutes org-columns--collect-values
  (defun org-agenda-columns--collect-values (&optional compiled-fmt m)
    "Collect values for columns on the current line.

  Return a list of triplets (SPEC VALUE DISPLAYED) suitable for
  `org-columns--display-here'.

  This function assumes `org-columns-current-fmt-compiled' is
  initialized is set in the current buffer.  However, it is
  possible to override it with optional argument COMPILED-FMT."
    (let ((summaries (get-text-property (point) 'org-summaries)))
      (mapcar
       (lambda (spec)
         (pcase spec
           (`(,p . ,_)
            (let* ((v (or (cdr (assoc spec summaries))
                          ;; first check if p is a special agenda (text) property
                          (when-let* ((prop-p (string-match "^AGENDA_\\(.+\\)" p))
                                      (prop-name (downcase (match-string 1 p))))
                            ;; if property is duration consider effort if it is not set
                            (if (string= prop-name "duration")
                                (if-let ((dur (org-get-at-bol (intern prop-name))))
                                    ;; if duration is negatie (i.e. time range crossess
                                    ;; midnight) then add 24h to duration
                                    (if (> dur 0.0)
                                        (propertize (org-duration-from-minutes dur)
                                                    'face 'org-scheduled)
                                      (propertize (org-duration-from-minutes
                                                   (+ dur (* 24 60)))
                                                  'face 'org-scheduled))
                                  (org-with-point-at m
                                    (org-entry-get
                                     (point) org-effort-property
                                     'selective t)))
                              (org-get-at-bol (intern prop-name))))
                          (org-with-point-at m
                            (org-entry-get (point) p 'selective t))
                          "")))
              ;; A non-nil COMPILED-FMT means we're calling from Org
              ;; Agenda mode, where we do not want leading stars for
              ;; ITEM.  Hence the optional argument for
              ;; `org-columns--displayed-value'.
              (list spec v (org-columns--displayed-value spec v compiled-fmt))))))
       (or compiled-fmt org-columns-current-fmt-compiled)))))


;; (after! 'org
(require 'org)
;; Org basics
(setq org-directory "~/org/")
(defun org-file-path (PATH) "Concatenates PATH to org-directory" (concat (expand-file-name org-directory) PATH))
(defvar +org-capture-meetings-file (org-file-path "meetings.org"))
(defvar +org-capture-gifts-file (org-file-path "gifts.org"))
(defvar +org-capture-inbox-file (org-file-path "inbox.org"))
(defvar +org-capture-dev-file (org-file-path "devenv.org"))
;; (defvar +org-capture-review-file (org-file-path "journal/planning-review.org"))
(defvar +org-capture-review-file  "/home/aus/org/journal/planning-review.org") ;; TODO
(setq org-agenda-sorting-strategy '(deadline-up priority-down tag-up)
      org-priority-lowest ?D
      ;; org-priority-faces nil
      org-id-link-to-org-use-id t
      org-refile-allow-creating-parent-nodes (quote confirm)
      org-todo-keywords '((sequence "TODO(t)"  "TRIAGE(g)" "INVESTIGATE(v)" "SOMEDAY(o)" "LEARN(l)" "READ(r)" "IDEA(i)" "PROJECT(p)" "STARTED(s)" "WAIT(w)" "BLOCKED(b)" "EXPECTING(e)" "|" "DONE(d)" "CANCELED(k)")
                          (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)"))
      org-archive-default-command #'org-archive-set-tag
      ;; prefix tag string with @ or use stargroup / endgroup vs grouptag for mutually exclusive
      org-tag-alist '(("work" . ?w)
                      ("gift" . ?g)
                      ("quote" . ?q)
                      ("family" . ?a)
                      ("pt" . ?t)
                      ("photo" . ?i)
                      (:startgrouptag . nil)
                      ;; ("Project" . ?p)
                      ;; (:grouptags)
                      ("faces" . ?f)
                      ("deployment" . ?y)
                      ("server" . ?s)
                      ("devenv" . ?d)
                      ("caf" . ?C)
                      ;; ("seg; ("autolighting" . ?l)
                      ("selfhosting" . ?h)
                      (:endgrouptag . nil)

                      (:startgrouptag . nil)
                      ;; ("Learning Areas")
                      ;; (:grouptags)
                      ("computer_science" . ?c)
                      ("machine_learning" . ?m)
                      ("organization" . ?o)
                      ("programs" . ?p)
                      (:endgrouptag . nil)
                      ;; For people
                      (:startgrouptag . nil)
                      ;; ("People")
                      ;; (:grouptags)
                      ("althea" . ?A)
                      ("tophi" . ?T)
                      ("henrik" . ?H)
                      ("soren" . ?S)
                      ("pat" . ?P)
                      ("katie" . ?E)
                      ("pa" . ?D)
                      ("ma" . ?M)
                      ("kenny" . ?K)
                      (:endgrouptag . nil))
      org-columns-default-format "%60ITEM(Task) %TODO %6Effort(Estim){:} %CLOCKSUM(Actual)"
      org-startup-with-inline-images t
      org-log-done 'time
      org-log-into-drawer t
      org-log-redeadline t
      org-log-reschedule t
      org-link-descriptive nil
      org-capture-templates
      '(("n" "Note" entry (file +org-capture-notes-file) "* %u %^G %?")
        ("t" "To-Do" entry (file +org-capture-todo-file) "* TODO %? %^G %^{EFFORT}p \nSCHEDULED: %^t" :prepend t)
        ("d" "Devenv" entry (file +org-capture-dev-file) "* TODO %? %^G %^{EFFORT}p" :prepend t)
        ("r" "Triage Note" entry (file +org-capture-todo-file) "* TRIAGE %?" :prepend t)
        ("e" "Email" entry (file +org-capture-todo-file) "* TODO %A %(org-set-tags \"email\")" :prepend t :post-hook (lambda () (org-store-link)))
        ("g" "Gift Idea" entry (file +org-capture-gifts-file) "* %? %^{For who?}G") ;%(org-set-tags \"gift\") %^{For who?}G")
        ("i" "Idea" entry (file +org-capture-todo-file) "* IDEA %? %^G")
        ;; TODO
        ("w" "Weeklies")
        ;; ("wd" "Daily Plan")
        ;; ("wD" "Daily Review")
        ("wp" "Weekly Plan" entry (file+datetree +org-capture-review-file) "* Weekly Goals
- %?"
         :tree-type week
         :time-prompt t
         :clock-in t
         :immediate-finish t
         :jump-to-captured t
         :clock-keep t
         :unnarrowed t)
        ("wr" "Weekly Review" entry (file+datetree +org-capture-review-file) "* Weekly Review %t
** Agenda
%(save-window-excursion (org-batch-agenda \"w\"))
** Clocktable
%(org-dynamic-block-insert-dblock \"clocktable\" nil)
* Reflection
%?"
         ;; %(org-batch-agenda \"E\") -- aborts
         :tree-type week
         :time-prompt t
         :clock-in t
         :immediate-finish t
         :jump-to-captured t
         :clock-keep t
         :unnarrowed t)
        ("m" "Meetings")
        ("mk" "Kim discussion point" entry (file+olp +org-capture-meetings-file "Kim" "Inbox")
         "* %?"
         :tree-type week
         :unnarrowed t)
        ("mK" "Kim meeting notes" entry (file+olp+datetree +org-capture-meetings-file "Kim")
         "* %?"
         :tree-type week
         :immediate-finish t
         :jump-to-captured t
         :clock-in t
         :clock-keep t
         :unnarrowed t)
        ("ms" "Steven discussion point" entry (file+olp +org-capture-meetings-file "Steven" "Inbox")
         "* %?"
         :tree-type week
         :unnarrowed t)
        ("mS" "Steven meeting notes" entry (file+olp+datetree +org-capture-meetings-file "Steven")
         "* %?"
         :tree-type week
         :immediate-finish t
         :jump-to-captured t
         :clock-in t
         :clock-keep t
         :unnarrowed t)
        ("mm" "Scheduled Meeting" entry (file+olp+datetree +org-capture-meetings-file)
         "* %^{What are we discussing?} - %^{Attendees?} %T %^G\n** Prep: %?"
         :prepend t
         :clock-in t
         :clock-resume t
         :time-prompt t)
        ("mn" "Impromptu Meeting" entry (file+olp+datetree +org-capture-meetings-file)
         "* %T - %^{Who?} %^G \n %?"
         :immediate-finish t
         :jump-to-captured t
         :clock-in t
         :clock-keep t)
        ;; ("p" "Templates for projects")
        ;; ("pt" "Project-local todo" entry (file+headline +org-capture-project-todo-file "Inbox") "* TODO %?" :prepend t)
        ;; ("pn" "Project-local notes" entry (file+headline +org-capture-project-notes-file "Inbox") "* %U %?" :prepend t)
        ;; ("pc" "Project-local changelog" entry (file+headline +org-capture-project-changelog-file "Unreleased") "* %U %?" :prepend t)
                                        ;("c" "calfw2org" entry (file+headline +org-capture-todo-file "Inbox") "* %? \nSCHEDULED: %(cfw:org-capture-day)" :prepend t :time-prompt)
        ("c" "calfw2org" entry (file+headline +org-capture-todo-file "Inbox") "* %? \nSCHEDULED: %(cfw:org-capture-day)")
        ("p" "Centralized templates for projects")
        ("pi" "Project idea" entry #'+org-capture-central-project-todo-file "* IDEA %?" :heading "Ideas")
        ("pt" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?" :heading "Tasks" :prepend nil)
        ("pn" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?" :heading "Notes" :prepend t)
        ("pc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?" :heading "Changelog" :prepend t)))

;; Fix for yasnippet tab key in org mode
(defun my/org-tab-conditional ()
  (interactive)
  (if (yas-active-snippets)
      (yas-next-field-or-maybe-expand)
    (org-cycle)))

;; Bindings
(map! :after evil-org
      :map evil-org-mode-map
      :i "<tab>" #'my/org-tab-conditional)
(map! :map evil-org-agenda-mode-map :m "d A" #'org-agenda-archive-default)

;; Modules
(add-to-list 'org-modules 'org-habit t)

;; Hooks
;; (add-hook 'org-after-todo-state-change-hook (lambda () (when (equal org-state "DONE") (org-toggle-archive-tag))) 100)
;; )

;; Make captures full screen
;; (defun stag-misanthropic-capture (&rest r)
;;   (delete-other-windows))
;; (advice-add  #'org-capture-place-template :after 'stag-misanthropic-capture)

;; Agenda
;; (after! 'org-agenda
(require 'org-agenda)
(setq org-agenda-files '("~/org/" "~/org/journal/")
      org-agenda-skip-deadline-if-done t
      org-agenda-skip-scheduled-if-done t
      org-agenda-columns-add-appointments-to-effort-sum t
      org-clock-clocktable-default-properties '(:scope agenda-with-archives :maxlevel 3 :emphasize nil :block thisweek :fileskip0 t :link nil :level nil :hidefiles t :filetitle t :compact t :narrow 70!)
      org-agenda-prefix-format
      '((agenda . " %i %-12:c%?-12t%-6e % s")
        (todo . " %i %-12:c %-6e")
        (tags . " %i %-12:c")
        (search . " %i %-12:c"))
      org-agenda-skip-scheduled-if-deadline-is-shown 'not-today
      org-agenda-clockreport-parameter-plist '(:link t :fileskip0 t :maxlevel 2 :scope agenda-with-archive :emphasize t)) ;; :block thisweek
;; (defun org-agenda-not-done () (org-agenda-skip-entry-if 'notregexp "^\\*\\* DONE "))
;; (defun org-agenda-not-done () (org-agenda-skip-entry-if 'notregexp "DONE"))
(defun org-agenda-not-done () (org-agenda-skip-entry-if 'nottodo 'done))
(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
         ((todo "TRIAGE")
          ;; TODO get only TODOS for this week and put here
          (tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (agenda "" ((org-agenda-start-day "0d") (org-agenda-span 1)))
          (agenda "" ((org-agenda-start-day "+1d") (org-agenda-span 6)))
          (alltodo "")))
        ("d" "Today"
         ((todo "TRIAGE")
          (tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (agenda "" ((org-agenda-start-day "0d") (org-agenda-span 1)))
          ))
        ("D" "Daily review"
         agenda ""
         ((org-agenda-start-day "-1d")
          (org-agenda-span 2)
          (org-agenda-archives-mode t)
          (org-agenda-skip-archived-trees nil)
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-skip-scheduled-if-done t)
          (org-agenda-use-time-grid nil)
          (org-agenda-start-with-log-mode '(closed clocked))
          (org-agenda-skip-function #'org-agenda-not-done)))
        ("w" "Weekly review"
         agenda ""
         (
          (org-agenda-start-day "-6d")
          (org-agenda-span 7)
          (org-agenda-span 'week)
          (org-agenda-skip-archived-trees nil)
          (org-export-with-archived-trees t)
          (org-agenda-archives-mode t)
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-skip-scheduled-if-done t)
          (org-agenda-start-on-weekday 1)
          (org-agenda-use-time-grid nil)
          (org-agenda-include-deadlines nil)
          (org-agenda-start-with-log-mode '(closed))
          (org-agenda-skip-function #'org-agenda-not-done)))
        ("W" "Fortnite review"
         agenda ""
         ((org-agenda-start-day "-13d")
          (org-agenda-span 14)
          (org-agenda-archives-mode t)
          (org-agenda-start-on-weekday 1)
          (org-agenda-skip-archived-trees nil)
          (org-export-with-archived-trees t)
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-skip-scheduled-if-done t)
          (org-agenda-use-time-grid nil)
          (org-agenda-start-with-log-mode '(closed clocked))
          (org-agenda-skip-function #'org-agenda-not-done)))
        ;; https://emacs.stackexchange.com/questions/58875/how-do-i-add-appointments-to-effort-sum
        ("j" "Planning Table"
         agenda ""
         ((org-agenda-overriding-header "")
          (org-agenda-start-day "0d")
          (org-agenda-span 1)
          (org-agenda-use-time-grid nil)
          (org-agenda-view-columns-initially t)
          (org-columns-default-format-for-agenda
           "%11AGENDA_TIME(When) %10TODO(Type) %3PRIORITY %40ITEM(What) %5AGENDA_DURATION(Duration){:} %10CLOCKSUM")
          ;; do not show warnings, overdue and overscheduled
          (org-scheduled-past-days 0)
          (org-deadline-past-days 0)
          (org-deadline-warning-days 0)
          ;; skip finished entries
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-skip-scheduled-if-done t)))))

(defun ak/export-weekly-done ()
  (save-window-excursion
    (org-agenda nil "E")
    (org-batch-agenda "E")
    (org-batch-agenda-csv "E")
    (org-store-agenda-views )))

;; Journal
(require 'org-journal)
;; (after! org-journal
(setq org-journal-file-format "journal-%Y%m%d.org"
      org-journal-file-type 'yearly)
;; )

;; Roam
;; (after! 'org-roam
(require 'org-roam)
(setq org-roam-directory "~/org/roam")
(org-roam-db-autosync-mode)
(setq org-roam-v2-ack t)
;; not sure why this doesn't work with variables
(setq org-roam-capture-templates '(("d" "default" plain "%?" :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n") :unnarrowed t)))
                                        ; add @ to prompt a note + others
(setq org-roam-dailies-capture-templates '(("d" "default" entry "* %<%-I:%M %p>: %?" :target
                                            (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
;; )

;; Org src blocks
;; (after! 'org-tempo
(require 'org-tempo) ;; This is needed as of Org 9.2
(add-to-list 'org-structure-template-alist '("t" . "src shell"))
(add-to-list 'org-structure-template-alist '("cs" . "src csharp"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("ru" . "src rust"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
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
;; (add-hook 'org-mode-hook (lambda()
;;                            (make-local-variable 'evil-insert-state-entry-hook) ;; making this hook act only locally in the buffer where org-mode-hook has been called
;;                            (add-hook 'evil-insert-state-entry-hook #'org-edit-src-code)))
;; (set-company-backend! 'org-mode '(:separate company-org-block company-files company-dabbrev company-ispell) 'company-capf)
;; (defun org-babel-edit-prep:rust (babel-info)
;;   (setq-local buffer-file-name (->> babel-info caddr (alist-get :tangle)))
;;   (lsp))


;; Quick insertion commands and hooks
;; add id to all captures
;; (add-hook 'org-capture-mode-hook #'org-id-get-create) ;https://www.reddit.com/r/orgmode/comments/eln9kb/capture_with_automatic_id_creation/
(map! :leader "i b" #'tempo-template-org-src)
;; )

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
;;(add-hook 'org-insert-heading-hook
;;         (lambda()
;;            (save-excursion
;;              (org-back-to-heading)
;;              (org-set-property "CREATED" (format-time-string "[%Y-%m-%d %a %H:%M]")))))
(defun ak/complete-time ()
  "Inserts a string in the following format"
  (interactive)
  (insert (concat (concat " <" (format-time-string "%A, %B %e, %Y | %-I:%M %p")) " >")))

(map! :leader "i C" 'ak/complete-time)

;; replace by org journal default behavior
;; (defun ak/remove-incomplete-checkboxes () (interactive)
;;        (beginning-of-buffer)
;;        (while (re-search-forward "\\[ \\] " nil t)
;;          (replace-match "" nil nil)))

;; (map! :leader "n r d x" 'ak/remove-incomplete-checkboxes)


;; (defun my/org-roam-copy-todo-to-today (&optional archive)
;;   (interactive)
;;   (let ((org-refile-keep t) ;; Set this to nil to delete the original!
;;         (org-roam-dailies-capture-templates
;;          '(("t" "tasks" entry "%?"
;;             :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
;;         (org-after-refile-insert-hook #'save-buffer)
;;         today-file
;;         pos)
;;     (save-window-excursion
;;       (org-roam-dailies--capture (current-time) t)
;;       (setq today-file (buffer-file-name))
;;       (setq pos (point)))

;;     ;; Only refile if the target file is different than the current file
;;     (unless (equal (file-truename today-file)
;;                    (file-truename (buffer-file-name)))
;;       (org-refile nil nil (list "Tasks" today-file nil pos)))
;;     (when archive (call-interactively #'org-archive-to-archive-sibling))
;;     ))

;;;; doesn't always check the box
;; (defun ak/toggle-org-checkbox () (interactive)
;;        (let ((time (format "\nCLOSED: [%s]" (format-time-string "%Y-%m-%d %a %H:%M"))))
;;          (progn (org-toggle-checkbox) (end-of-line) (insert time))))
;; (add-hook 'org-mode-hook (lambda () (map! :leader "m x" #'ak/toggle-org-checkbox)))


                                        ; todo org-protocol and org-roam-protocol

;; Future items
;; for showing effort:
;; #+PROPERTY: Effort_ALL 0 0:10 0:30 1:00 2:00 3:00 4:00 5:00 6:00 7:00
;; #+COLUMNS: %30ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM

;; (require 'cl-lib)

;; (defun my/org-agenda-calculate-efforts (limit)
;;   "Sum the efforts of scheduled entries up to LIMIT in the
;; agenda buffer."
;;   (let (total)
;;     (save-excursion
;;       (while (< (point) limit)
;;         (when (member (org-get-at-bol 'type) '("scheduled" "past-scheduled"))
;;           (push (org-entry-get (org-get-at-bol 'org-hd-marker) "Effort") total))
;;         (forward-line)))
;;     (org-duration-from-minutes
;;      (cl-reduce #'+
;;                 (mapcar #'org-duration-to-minutes
;;                         (cl-remove-if-not 'identity total))))))

;; (defun my/org-agenda-insert-efforts ()
;;   "Insert the efforts for each day inside the agenda buffer."
;;   (save-excursion
;;     (let (pos)
;;       (while (setq pos (text-property-any
;;                         (point) (point-max) 'org-agenda-date-header t))
;;         (goto-char pos)
;;         (end-of-line)
;;         (insert-and-inherit (concat " ("
;;                                     (my/org-agenda-calculate-efforts
;;                                      (next-single-property-change (point) 'day))
;;                                     ")"))
;;         (forward-line)))))
;; (add-hook 'org-agenda-finalize-hook 'my/org-agenda-insert-efforts)
