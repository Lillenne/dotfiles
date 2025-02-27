;;; org.el -*- lexical-binding: t; -*-

;; (after! 'org
(require 'org)
(defun ak/from-org-dir (TEXT)
  (require 's)
  (if (stringp TEXT)
      (expand-file-name (if (s-ends-with? ".org" TEXT t) TEXT (concat TEXT ".org"))
                        org-directory)))
(defun ak/from-org-dir-all (&rest args)
  (let ((collect '()))
    (dolist (arg args)
      (push (ak/from-org-dir arg) collect))
    collect))

(load! "quick-jump.el")
(defun ak/to-sprint ()
  "Creates a new sprint heading"
  (interactive)
  ;; Go to end of previous sprint subtree
  (org-id-goto "de9f62ef-9e3a-42d3-af91-b3a710d2a958")
  (org-mode)
  (require 'org-element)
  (org-end-of-subtree)
  (let* ((headline (org-element-context))
         (previous (org-element-lineage-map headline #'identity 'headline t t)))
    (goto-char (org-element-begin previous))
    (end-of-line)
    (search-backward "[" (line-beginning-position))
    (unless (org-at-timestamp-p t) (error "Didn't find previous sprint!"))
    ;; (org-element-property :raw-value (org-element-context))
    (when (< (org-timestamp-to-now (buffer-substring-no-properties (point) (search-forward "]" (line-end-position))) ) 0) ;; timestamp has passed, create next heading
      (let* ((text (org-element-property :raw-value (org-element-context))))
        (org-insert-heading t)
        (insert text))
      ;; Increment sprint timestamps
      (dotimes (_ 2)
        (search-backward "[" (line-beginning-position) t)
        (org-timestamp-up-day 14)))
    (end-of-line)))
(map! :leader "j s" #'ak/to-sprint)

;; Org basics
(setq org-directory "~/org/"
      org-startup-folded 'show2levels
      org-columns-default-format "%TODO %3PRIORITY %60ITEM(Task) %6Effort(Estim){:} %CLOCKSUM(Actual) %TAGS"
      org-global-properties '(("Effort_ALL" . "0:05 0:15 0:30 1:00 2:00 4:00 8:00 16:00 24:00")))

;; (defun ak/new-sprint-headline ()
;;   "Updates the sprint headline directly above"
;;   (save-excursion
;;     (org-previous-visible-heading)
;;     (let ((text (org-element-property :title (org-element-at-point))))
;;       (org-insert-heading t)
;;       (insert text))
;;     ;; Increment sprint timestamps
;;     (while (search-backward "[" (line-beginning-position) t)
;;       (org-timestamp-up-day 14)))
;;   ()))

(defun ak/complete-recurring-task (ID)
  (save-window-excursion
    (org-id-goto ID)
    (org-todo 'done)))

;; org crypt
(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-crypt-key "0x7C9F982201FF5847!") ;; use symmetric encryption
(setq org-tags-exclude-from-inheritance '("crypt"))
;; disable autosave globally
;; (setq auto-save-default nil)
;; disable autosave locally
;; # -*- buffer-auto-save-file-name: nil; -*-

(defun my/org-archive-all-done-in-file (ARG)
  (interactive "P")
  (require 'org-archive)
  (org-map-entries (lambda ()
                     (when (member (org-entry-get nil "TODO") org-done-keywords)
                       (cond ((eql (car ARG) 4) (org-archive-subtree))
                             ((eql (car ARG) 16) (org-archive-set-tag))
                             (t (org-archive-subtree-default)))
                       (setq org-map-continue-from (org-element-property :begin (org-element-at-point)))))))
(map! :map org-mode-map :desc "Archive all done" :leader "n z" #'my/org-archive-all-done-in-file)

(add-to-list 'auto-mode-alist '("\\.org_archive\\'" . org-mode))

;; Don't insert blank lines after items
(setf org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))

(setq
 org-icalendar-combined-agenda-file (expand-file-name "org.ics" org-directory)
 org-export-with-broken-links t
 org-icalendar-ttl "PT1H" ;; 1 hr
 org-icalendar-include-body 0
 org-icalendar-timezone "America/Los_Angeles"
 ;;org-agenda-sorting-strategy '(deadline-up priority-down tag-up)
 org-priority-lowest ?D
 org-clock-continuously nil ;; t to make clock start times the previous clock end times, nil to stop
 org-clock-idle-time '30
 org-priority-faces nil
 ;; org-id-link-to-org-use-id t ;; use ids for links. Sometimes creates them unnecessarily
 org-refile-allow-creating-parent-nodes 'confirm
 org-todo-keywords '((sequence "TODO(t)" "NEXT(n)"  "TRIAGE(r)" "INVESTIGATE(v/@)" "SOMEDAY(o)" "LEARN(l)" "IDEA(i)" "STARTED(s)" "BLOCKED(b@)" "|" "DONE(d)" "CANCELED(k@)")
                     (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)"))
 ;; org-archive-mark-done "CANCELED"
 org-archive-default-command #'org-archive-set-tag
 ;; org-archive-default-command #'org-archive-subtree
 ;; org-archive-location "~/org/archive.org::datetree/"
 org-archive-location "~/org/archive.org_archive::* %s"
 ;; prefix tag string with @ or use stargroup / endgroup vs grouptag for mutually exclusive
 org-tag-alist '(("work" . ?w)
                 ;; TODO limit tags
                 ("gift" . ?g)
                 ("quote" . ?q)
                 ("family" . ?a)
                 (:startgrouptag . nil)
                 ;; ("Project" . ?p)
                 ;; (:grouptags)
                 ;; ("deployment" . ?y)
                 ;; ("server" . ?s) ;; lump in with devenv
                 ("memories" .?e) ;; should just go in memories file with filetag
                 ("devenv" . ?d)
                 ;; ("caf" . ?C)
                 ;; ("langs" . ?l)
                 ;; ("seg; ("autolighting" . ?l)
                 ;; ("selfhosting" . ?h) ;; lump in with devenv
                 (:endgrouptag . nil)
                 ;; ("career" . ?r)

                 (:startgrouptag . nil)
                 ;; ("Learning Areas")
                 ;; (:grouptags)
                 ("computer_science" . ?c)
                 ;; ("machine_learning" . ?m) ;; lump in with cs
                 ("organization" . ?o) ;; TODO remove?
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
 org-startup-with-inline-images nil
 org-log-done 'time
 org-log-into-drawer t
 org-log-redeadline t
 org-log-reschedule 'time
 org-link-descriptive t
 ;; split-height-threshold 0
 ;; split-width-threshold nil
 org-capture-templates
 `(("a" "Appointments")
   ("aa" "Appointment" entry (file ,(ak/from-org-dir "calendar.org"))
    "* %?\n:PROPERTIES:\n:calendar-id:\t%(getenv \"GMAIL\")\n:END:\n:org-gcal:\n%^T--%^T\n:END:\n\n" :jump-to-captured t)
   ("af" "Family Appointment" entry (file ,(ak/from-org-dir "calendar_family.org"))
    "* %?\n:PROPERTIES:\n:calendar-id:\t%(getenv \"GCAL_FAMILY\")\n:END:\n:org-gcal:\n%^T--%^T\n:END:\n\n" :jump-to-captured t)
   ("c" "Current Clock" plain (clock) "%?" :unnarrowed t)
   ("t" "To-Do" entry (file +org-capture-todo-file) "* TODO %? %^G %^{EFFORT}p \nSCHEDULED: %^t" :prepend t)
   ("d" "Devenv" entry (file +org-capture-devenv-file) "* TODO %? %^G %^{EFFORT}p" :prepend t)
   ;; ("r" "Triage Note" entry (file +org-capture-todo-file) "* TRIAGE %?" :prepend t)
   ("l" "Learn" entry (file ,(ak/from-org-dir "learn")) "* LEARN %^{What category?}G %?" :prepend t)
   ("e" "Email" entry (file ,(ak/from-org-dir "todo")) "* TODO %A %(org-set-tags \"email\")" :prepend t :post-hook (lambda () (org-store-link)))
   ("g" "Gift Idea" entry (file ,(ak/from-org-dir "gifts")) "* %? %^{For who?}G") ;%(org-set-tags \"gift\") %^{For who?}G")
   ("w" "Work")
   ("ww" "Work todo" entry (file+headline ,(ak/from-org-dir "work") "Todo") "* TODO %? %^{EFFORT}p \nSCHEDULED: %^t" :prepend t)
   ("wr" "PR Review" entry (file+headline ,(ak/from-org-dir "work") "PRs") "* TODO %^{What?} :%^{Who|ron|jeremy|bo|jared|peter}:
%u
%?"
    :clock-in t
    :clock-keep t
    :jump-to-captured t
    :immediate-finish t)
   ("wR" "PR Later" entry (file+headline +org-capture-work-file "PRs") "* TODO %^{What?} :%^{Who|ron|jeremy|bo|jared|peter}:\nSCHEDULED: %^t"
    :immediate-finish t)
   ("i" "Idea" entry (file +org-capture-todo-file) "* IDEA %? %^G")
   ("j" "Journal")
   ("jc" "New encrypted journal entry" entry
    (file+olp+datetree "~/org/personal/journal.org.gpg")
    "* %U - %?" :tree-type week)
   ("jw" "Weeklies")
   ("jwp" "Weekly Plan" entry (file+datetree +org-capture-journal-file) "* Weekly Plan
Goals
- %^{Goal|None}
- %^{Goal|None}
- %^{Goal|None}

%?"
    :tree-type week
    :time-prompt t
    :clock-in t
    :after-finalize (lambda () (ak/complete-recurring-task "963e452d-1202-41bf-8361-5caa25ad6511"))
    :clock-resume t
    :unnarrowed t)
   ("jwr" "Weekly Review" entry (file+datetree +org-capture-journal-file) "* Weekly Review
- Pre review [/]
  - [ ] Clear off desk %?
  - [ ] Clear Teams notifications & respond to messages
  - [ ] Catch up on email
    - [ ] Work
    - [ ] Personal
- Housekeeping [/]
  - [ ] Untriaged notes
  - [ ] Overdue items
  - [ ] Blocked items
  - [ ] Unscheduled items
- Review [/]
  - [ ] What went well?
  - [ ] What slipped?
  - [ ] What did I not need to do?
  - [ ] What can I adjust or start? Create a plan.
- Planning [/]
  - Main priorities for next week
    1.

** Agenda
%(save-window-excursion (org-batch-agenda \"W\"))
** Clocktable
%(org-dynamic-block-insert-dblock \"clocktable\" nil)"
    :tree-type week
    :time-prompt t
    :clock-in t
    :immediate-finish t
    :jump-to-captured t
    :after-finalize (lambda () (ak/complete-recurring-task "689d7bf9-bf59-4ad3-bfbe-024c3beed495"))
    :clock-keep t
    :unnarrowed t)
   ("jp" "Daily plan" entry (file+olp+datetree +org-capture-journal-file) "* %(format-time-string \"%-I:%M %p\"): Daily planning\n%?\n** Yesterday:
%(save-window-excursion (org-batch-agenda \"y\"))"
    :tree-type week
    :clock-in t
    :clock-keep t
    :immediate-finish t
    :after-finalize (lambda () (ak/complete-recurring-task "6323b0c4-6455-413c-9e05-e5420818b72e"))
    :jump-to-captured t)
   ("jP" "Daily plan (other day)" entry (file+olp+datetree +org-capture-journal-file) "* Daily planning\n%?"
    :tree-type week
    :time-prompt t
    :clock-in t
    :clock-keep t
    :immediate-finish t
    :jump-to-captured t)
   ("js" "Standup notes" entry (file+olp+datetree +org-capture-journal-file) "* %(format-time-string \"%-I:%M %p\"): Standup notes\n%?\n** Yesterday:
%(save-window-excursion
(if (string= (format-time-string \"%-a\") \"Mon\")
   (org-batch-agenda \"l\")
 (org-batch-agenda \"y\")))
** Today \n
%(save-window-excursion (org-batch-agenda \"D\"))"
    :tree-type week
    :clock-in t
    :clock-keep t
    :immediate-finish t
    :jump-to-captured t)
   ("jr" "Daily Review" entry (file+olp+datetree +org-capture-journal-file) "* %(format-time-string \"%-I:%M %p\"): Daily Review\n
- Pre review [/]
  - [ ] Clear off desk %?
  - [ ] Catch up on email
  - [ ] Clear Teams notifications & respond to messages
- Housekeeping [/]
  - [ ] Untriaged notes
  - [ ] Overdue items
  - [ ] Blocked items
- Review
  - Accomplished:
  - Blockers:
  - Didn't get to:
  - Notes
- [ ] Plan tomorrow
  1.
  2.
  3.

** %(save-window-excursion (org-batch-agenda \"D\"))"
    :tree-type week
    :clock-in t
    :clock-keep t
    :immediate-finish t
    :after-finalize (lambda () (ak/complete-recurring-task "57331d3b-c20d-43f5-ad21-2a3a40e88a98"))
    :jump-to-captured t)
   ("jR" "Daily Review (later)" entry (file+olp+datetree +org-capture-journal-file) "* Daily Review\n%?"
    :tree-type week
    :time-prompt t
    :clock-in t
    :clock-keep t
    :immediate-finish t
    :jump-to-captured t)
   ("jn" "Now" entry (file+olp+datetree +org-capture-journal-file) "* %(format-time-string \"%-I:%M %p\"): %?"
    :tree-type week
    :clock-in t
    :clock-resume t
    :unnarrowed t)
   ("jN" "Start task" entry (file+olp+datetree +org-capture-journal-file) "* %(format-time-string \"%-I:%M %p\"): %^{Task?} %?"
    :tree-type week
    :clock-in t
    :clock-keep t
    :immediate-finish t)
   ("jl" "Later" entry (file+olp+datetree +org-capture-journal-file) "* %^{Entry headline?}\n%U%?"
    :tree-type week
    :time-prompt t
    :unnarrowed t)
   ("jL" "Later (all day)" entry (file+olp+datetree +org-capture-journal-file) "* %^{Entry headline?}\n%u%?"
    :tree-type week
    :time-prompt t
    :unnarrowed t)
   ("je" "Event" entry (file+olp+datetree +org-capture-journal-file) "* %^{Event?}\n%T%?"
    :tree-type week
    :time-prompt t
    :unnarrowed t)
   ("jE" "Event (all day)" entry (file+olp+datetree +org-capture-journal-file) "* %^{Event?}\n%t%?"
    :tree-type week
    :time-prompt t
    :unnarrowed t)
   ("M" "Memories" entry (file +org-capture-memories-file) "* %?")
   ("m" "Meetings")
   ("mk" "Kim discussion point" entry (file+olp ,+org-capture-meetings-file "Kim" "Inbox")
    "* %?"
    :unnarrowed t)
   ("mK" "Kim meeting notes" entry (file+olp+datetree ,+org-capture-meetings-file "Kim")
    "* %?"
    :tree-type week
    :immediate-finish t
    :jump-to-captured t
    :clock-in t
    :clock-keep t
    :unnarrowed t)
   ("mx" "Sioux discussion point" entry (file+olp ,+org-capture-meetings-file "Sioux" "Inbox")
    "* %?"
    :unnarrowed t)
   ("mX" "Sioux meeting notes")
   ("mXa" "My GenAI project" plain (file+olp+datetree ,+org-capture-meetings-file "Sioux" "My GenAI Project")
    "%?"
    :tree-type week
    :immediate-finish t
    :jump-to-captured t
    :clock-in t
    :clock-keep t
    :unnarrowed t)
   ("mXm" "Michelle's GenAI project" plain (file+olp+datetree +org-capture-meetings-file "Sioux" "Michelle's GenAI Project")
    "%?"
    :tree-type week
    :immediate-finish t
    :jump-to-captured t
    :clock-in t
    :clock-keep t
    :unnarrowed t)
   ("ms" "Steven discussion point" entry (file+olp +org-capture-meetings-file "Steven" "Inbox")
    "* %?"
    :unnarrowed t)
   ("mS" "Steven meeting notes" entry (file+olp+datetree +org-capture-meetings-file "Steven")
    "* %?"
    :tree-type week
    :immediate-finish t
    :jump-to-captured t
    :clock-in t
    :clock-keep t
    :unnarrowed t)
   ("md" "Algo integration note" entry (file+olp +org-capture-meetings-file "Algorithm Integration" "Inbox")
    "* %?"
    :unnarrowed t)
   ("mD" "Algorithm integration w/ David" entry (file+olp+datetree +org-capture-meetings-file "Algorithm Integration")
    "* %?"
    :tree-type week
    :immediate-finish t
    :jump-to-captured t
    :clock-in t
    :clock-keep t
    :unnarrowed t)
   ("mm" "Scheduled Meeting" entry (file+olp+datetree +org-capture-meetings-file "Meetings")
    "* %^{What are we discussing?} - %^{Attendees?} %T %^G\n** Prep: %?"
    :prepend t
    :tree-type week
    :clock-in t
    :clock-resume t
    :time-prompt t)
   ("mn" "Impromptu Meeting" entry (file+olp+datetree +org-capture-meetings-file "Meetings")
    "* %^{Who?} %^G \n%T\n %?"
    :tree-type week
    :immediate-finish t
    :jump-to-captured t
    :clock-in t
    :clock-keep t)
   ("p" "Templates for projects")
   ("pt" "Project-local todo" entry (file+headline +org-capture-project-todo-file "Inbox") "* TODO %?" :prepend t)
   ("pn" "Project-local notes" entry (file+headline +org-capture-project-notes-file "Inbox") "* %U %?" :prepend t)
   ("pc" "Project-local changelog" entry (file+headline +org-capture-project-changelog-file "Unreleased") "* %U %?" :prepend t)
   ;; ("c" "calfw2org" entry (file+headline +org-capture-todo-file "Inbox") "* %? \nSCHEDULED: %(cfw:org-capture-day)" :prepend t :time-prompt)
   ("c" "calfw2org" entry (file+headline +org-capture-todo-file "Inbox") "* %? \nSCHEDULED: %(cfw:org-capture-day)")
   ("P" "Centralized templates for projects")
   ("Pi" "Project idea" entry #'+org-capture-central-project-todo-file "* IDEA %?" :heading "Ideas")
   ("Pt" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?" :heading "Tasks" :prepend nil)
   ("Pn" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?" :heading "Notes" :prepend t)
   ("Pc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?" :heading "Changelog" :prepend t)
   ))

(with-eval-after-load 'org-capture
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("h"                ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
                 (file+olp "all-posts.org" "Blog Ideas")
                 (function org-hugo-new-subtree-post-capture-template))))

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)

;; https://emacs.stackexchange.com/questions/34503/programmatically-start-clock-of-specific-heading-org-mode
(defun my/start-heading-clock (id file)
  "Start clock programmatically for heading with ID in FILE."
  (require 'org-id)
  (if-let (marker (org-id-find-id-in-file id file t))
      (with-current-buffer
          (set-buffer (marker-buffer marker))
        (goto-char (marker-position marker))
        (org-clock-in))
    (warn "Clock not started (Could not find ID '%s' in file '%s')" id file)))
(map! :leader :desc "Clock config" "n i c" #'(lambda () (interactive) (my/start-heading-clock "0d28712a-e265-4e1c-8210-7487e1da597a" "/home/aus/org/projects.org")))
(map! :leader :desc "Clock organization" "n i o" #'(lambda () (interactive) (my/start-heading-clock "946ea368-5645-4d81-b2fe-f8a287d7acc8" "/home/aus/org/projects.org")))
(map! :leader :desc "Clock answer questions" "n i q" #'(lambda () (interactive) (my/start-heading-clock "ebacb25c-cbe1-4742-be59-385cc1a31b2c" "/home/aus/org/work.org")))
(map! :leader :desc "Clock Emacs" "n i e" #'(lambda () (interactive) (my/start-heading-clock "6da4661c-bdad-4f14-9202-d3a039807c9d" "/home/aus/org/projects.org")))
(map! :leader :desc "Clock Teams" "n i t" #'(lambda () (interactive) (my/start-heading-clock "ea3dc712-93d8-49d1-b35d-c84a239bc239" "/home/aus/org/projects.org")))
(map! :leader :desc "Clock email" "n i E" #'(lambda () (interactive) (my/start-heading-clock "2f8d99c7-7f88-43ae-9f30-17bd44a5e29b" "/home/aus/org/projects.org")))
(map! :leader :desc "Clock in recent" "n i i" #'(lambda () (interactive)
                                                  (if (org-clock-is-active)
                                                      (org-clock-goto)
                                                    (save-window-excursion
                                                      (find-file +org-capture-todo-file)
                                                      (org-clock-in '(4))))))
(map! :leader :desc "Goto clock" "n g" #'org-clock-goto)
(map! :leader :desc "Clock out" "n o" #'org-clock-out)

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
(map! :map evil-org-agenda-mode-map :m "f" #'org-agenda-follow-mode)
(map! :map org-mode-map :leader "n ." #'consult-org-heading)
(map! :leader "n /" #'consult-org-agenda)

;; Modules
(add-to-list 'org-modules 'org-habit t)

;; Hooks
;; (add-hook 'org-after-todo-state-change-hook (lambda () (when (equal org-state "DONE") (org-toggle-archive-tag))) 100)
;; )

;; Make captures full screen
;; (defun stag-misanthropic-capture (&rest _)
;;   (delete-other-windows))
;; (advice-add  #'org-capture-place-template :after 'stag-misanthropic-capture)

;; Agenda
;; (after! 'org-agenda
(require 'org-agenda)
(require 'org-clock)
(defvar my/report-clock-var '(:maxlevel 5 :scope agenda-with-archives :fileskip0 t :filetitle t :compact t :link t))
(defun my/weekly-report-days ()
  (interactive)
  (let* ((last-monday (org-read-date nil nil "++0" nil (org-read-date nil t "-mon")))
         (org-clock-clocktable-default-properties (org-combine-plists my/report-clock-var '(:step day :tstart ,last-monday :tend "<now>"))))
    (org-dynamic-block-insert-dblock "clocktable" nil)))

(defun my/daily-report ()
  (interactive)
  (let* ((org-clock-clocktable-default-properties (org-combine-plists my/report-clock-var '(:block today))))
    (org-dynamic-block-insert-dblock "clocktable" nil)))

(defun my/weekly-report-week ()
  (interactive)
  (let* ((last-monday (org-read-date nil nil "++0" nil (org-read-date nil t "-mon")))
         (org-clock-clocktable-default-properties (org-combine-plists my/report-clock-var '(:block thisweek))))
    (org-dynamic-block-insert-dblock "clocktable" nil)))

(defun my/weekly-report-last-week ()
  (interactive)
  (let* ((last-monday (org-read-date nil nil "++0" nil (org-read-date nil t "-mon")))
         (org-clock-clocktable-default-properties (org-combine-plists my/report-clock-var '(:block lastweek))))
    (org-dynamic-block-insert-dblock "clocktable" nil)))


(setq org-agenda-files `(,org-directory)
      org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-start-day "0d"
      org-agenda-time-grid '((daily today require-timed) (800 1000 1200 1400 1600 1800 2000) "" "")
      ;; org-agenda-block-separator nil
      ;; org-agenda-compact-blocks t
      org-agenda-start-with-log-mode t
      org-deadline-warning-days 0
      org-agenda-columns-add-appointments-to-effort-sum t
      ;; org-clock-clocktable-default-properties '(:scope agenda :maxlevel 4 :emphasize nil :block thisweek :fileskip0 t :link nil :level nil :hidefiles t :filetitle t :compact t :narrow 70!)
      org-clock-clocktable-default-properties '(:scope agenda-with-archives :maxlevel 4 :emphasize nil :block thisweek :fileskip0 t :link nil :level nil :hidefiles t :filetitle t :compact t :narrow 70!)
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
(require 'org-super-agenda)
(org-super-agenda-mode)

;; (setq org-super-agenda-groups
;;       '((:discard (:tag "work"))
;;         (:name "Scheduled" :time-grid t :transformer (--> it (upcase it)))
;;         (:name "Overdue" :deadline past)
;;         (:name "Due today" :deadline today)
;;         (:name "Scheduled earlier" :scheduled past)
;;         (:name "Due soon" :deadline future)
;;         (:name "Habits" :habit t)
;;         (:name "Today" :scheduled today)
;;         (:name "Important" :priority "A")
;;         (:name "Quick Picks" :effort< "0:30")
;;         (:name "Done today" :and (:regexp "State \"DONE\"" :log t))
;;         (:name "Clocked today" :log t)))
;; (org-search-view)
;; (defun my/org-agenda ()
;;   (interactive)
;;   (call-interactively #'org-agenda)
;;   (org-agenda-archives-mode t))
;; (map! :desc "Org agenda" :leader "n a" #'my/org-agenda)

(require 'org-tree-slide)
(org-tree-slide-simple-profile)
;; (org-tree-slide-presentation-profile)
(setq +org-present-text-scale 2
      org-tree-slide-header nil)

;; (require 'org-present)
(advice-remove #'org-tree-slide--display-tree-with-narrow #'+org-present--hide-first-heading-maybe-a)

;; sample gtd from  https://github.com/aspiers/worg/blob/master/org-tutorials/org-custom-agenda-commands.org
;; (setq org-agenda-custom-commands
;;       '(("Q" . "Custom queries") ;; gives label to "Q"
;; 	("Qa" "Archive search" search ""
;; 	 ((org-agenda-files (file-expand-wildcards "~/archive/*.org"))))
;; 	("Qw" "Website search" search ""
;; 	 ((org-agenda-files (file-expand-wildcards "~/website/*.org"))))
;; 	("Qb" "Projects and Archive" search ""
;; 	 ((org-agenda-text-search-extra-files (file-expand-wildcards "~/archive/*.org"))))
;; 	        ;; searches both projects and archive directories
;; 	("QA" "Archive tags search" org-tags-view ""
;; 	 ((org-agenda-files (file-expand-wildcards "~/archive/*.org"))))
;; 	;; ...other commands here
;; 	 ))
(setq org-agenda-custom-commands
      '(
        ("h" "Agenda" ((agenda "" ((org-super-agenda-groups
                                    '(
                                      (:name "Scheduled" :time-grid t :transformer (--> it (upcase it)))
                                      (:discard (:tag "work"))
                                      (:name "Habits" :habit t)
                                      (:name "Triage" :todo "TRIAGE")
                                      (:name "Next" :todo "NEXT")
                                      (:name "Blocked" :todo "BLOCKED")
                                      (:name "Overdue" :deadline past)
                                      (:name "Due today" :deadline today)
                                      (:name "Scheduled earlier" :scheduled past)
                                      (:name "Due soon" :deadline future)
                                      (:name "Today" :scheduled today)
                                      (:name "Important" :priority "A")
                                      (:name "Quick Picks" :effort< "0:30")
                                      (:name "Done today" :and (:regexp "State \"DONE\"" :log t))
                                      (:name "Clocked today" :log t)))
                                   (org-agenda-span 4)
                                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                                   ))))
        ("w" "Work Agenda" ((agenda "" ((org-super-agenda-groups
                                         '(
                                           (:name "Scheduled" :time-grid t :transformer (--> it (upcase it)))
                                           (:name "Habits" :habit t)
                                           (:name "Triage" :todo "TRIAGE")
                                           (:name "Next" :todo "NEXT")
                                           (:name "Blocked" :todo "BLOCKED")
                                           (:name "Overdue" :deadline past)
                                           (:name "Due today" :deadline today)
                                           (:name "Scheduled earlier" :scheduled past)
                                           (:name "Due soon" :deadline future)
                                           (:name "Today" :scheduled today)
                                           (:name "Important" :priority "A")
                                           (:name "Quick Picks" :effort< "0:30")
                                           (:name "Done today" :and (:regexp "State \"DONE\"" :log t))
                                           (:name "Clocked today" :log t)))
                                        (org-agenda-span 4)
                                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                                        ))))

        ("b" "Blocked" ((todo "BLOCKED")))
        ("c" "Simple agenda view"
         (
          ;; Todos I haven't finished writing
          (todo "TRIAGE")

          (todo "NEXT")
          ;; This week
          (agenda ""
                  ((org-agenda-span 'week)
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                   (org-agenda-start-day "0d")))
          ;; (agenda "" ((org-agenda-start-day "0d") (org-agenda-span 1)))
          ;; (agenda "" ((org-agenda-start-day "+1d") (org-agenda-span 6)))
          ;; (alltodo "")
          ;; things I probably shouldn't forget about
          (tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (todo "BLOCKED")
          (todo ""
                ((org-agenda-overriding-header "\nUnscheduled TODO")
                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp))))
          ))
        ("d" "Today"
         ((todo "TRIAGE")
          (agenda "" ((org-super-agenda-groups
                       '(
                         (:name "Done today" :and (:regexp "State \"DONE\"" :log t))
                         ;; (:name "Habits" :habit t) ;; Not sure why this is causing an error
                         (:name "Scheduled" :time-grid t)
                         (:name "Clocked today" :log t)
                         (:discard (:tag "work"))
                         (:name "Overdue" :deadline past)
                         (:name "Due today" :deadline today)
                         (:name "Scheduled earlier" :scheduled past)
                         (:name "Quick Picks" :effort< "0:30")
                         (:name "Blocked" :todo "BLOCKED")
                         (:name "Today" :scheduled today)
                         ))
                      (org-agenda-start-day "0d")
                      (org-agenda-span 1)))
          ;; (tags "PRIORITY=\"A\""
          ;;       ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
          ;;        (org-agenda-overriding-header "High-priority unfinished tasks:")))
          ;; (todo "BLOCKED")
          ))
        ;; ("D" "Today w/ work"
        ;;  ((todo "TRIAGE")
        ;;   (agenda "" ((org-super-agenda-groups
        ;;                '((:name "Done today" :and (:regexp "State \"DONE\"" :log t))
        ;;                  ;; (:name "Habits" :habit t) ;; Not sure why this is causing an error
        ;;                  (:name "Scheduled" :time-grid t)
        ;;                  (:name "Clocked today" :log t)
        ;;                  (:name "Overdue" :deadline past)
        ;;                  (:name "Due today" :deadline today)
        ;;                  (:name "Scheduled earlier" :scheduled past)
        ;;                  (:name "Quick Picks" :effort< "0:30")
        ;;                  (:name "Blocked" :todo "BLOCKED")
        ;;                  (:name "Today" :scheduled today)
        ;;                  ))
        ;;               (org-agenda-start-day "0d")
        ;;               (org-agenda-span 1)))
        ;;   ;; (tags "PRIORITY=\"A\""
        ;;   ;;       ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
        ;;   ;;        (org-agenda-overriding-header "High-priority unfinished tasks:")))
        ;;   ;; (todo "BLOCKED")
        ;;   ))
        ("y" "Yesterday review"
         agenda ""
         ((org-agenda-start-day "-1d")
          (org-agenda-span 2)
          (org-agenda-start-with-archives-mode t)
          (org-agenda-archives-mode t)
          (org-agenda-skip-archived-trees nil)
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-skip-scheduled-if-done t)
          (org-agenda-use-time-grid nil)
          (org-agenda-hide-tags-regexp ".*")
          (org-agenda-start-with-log-mode 'only)
          (org-agenda-log-mode-items '(closed clock))))
        ;; (org-agenda-start-with-log-mode '(closed clock))))
        ("Y" "Yesterday review completed"
         agenda ""
         ((org-agenda-start-day "-1d")
          (org-agenda-span 1)
          (org-agenda-start-with-archives-mode t)
          (org-agenda-archives-mode t)
          (org-agenda-skip-archived-trees nil)
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-skip-scheduled-if-done t)
          (org-agenda-hide-tags-regexp ".*")
          (org-agenda-use-time-grid nil)
          (org-agenda-start-with-log-mode 'only)
          (org-agenda-log-mode-items '(closed clock))
          ;; (org-agenda-start-with-log-mode '(closed clock))
          (org-agenda-skip-function #'org-agenda-not-done)))
        ("D" "Daily review"
         agenda ""
         ((org-agenda-start-day "0d")
          (org-agenda-span 1)
          (org-agenda-start-with-archives-mode t)
          (org-agenda-archives-mode 'files)
          (org-agenda-skip-archived-trees nil)
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-hide-tags-regexp ".*")
          (org-agenda-skip-scheduled-if-done t)
          (org-agenda-use-time-grid nil)
          (org-agenda-start-with-log-mode 'only)
          (org-agenda-log-mode-items '(closed clock))
          ;; (org-agenda-start-with-log-mode '(closed clock))
          ;; (org-agenda-skip-function #'org-agenda-not-done)
          ))
        ;; ("w" "Weekly plan"
        ;;  agenda ""
        ;;  ((org-agenda-span 'week)
        ;;   (org-agenda-start-day "0d")))
        ("W" "Weekly review"
         agenda ""
         (
          ;; (org-agenda-start-day "-6d")
          (org-agenda-span 7)
          (org-agenda-start-with-archives-mode t)
          ;; (org-agenda-span 'week)
          (org-agenda-skip-archived-trees nil)
          (org-export-with-archived-trees t)
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-skip-scheduled-if-done t)
          (org-agenda-hide-tags-regexp ".*")
          (org-agenda-start-on-weekday 1)
          (org-agenda-use-time-grid nil)
          (org-agenda-include-deadlines nil)
          (org-agenda-archives-mode t)
          ;; (org-agenda-start-with-log-mode '(closed clock))
          (org-agenda-start-with-log-mode 'only)
          (org-agenda-log-mode-items '(closed clock))
          (org-agenda-skip-function #'org-agenda-not-done)))
        ("l" "Last week review" ;; supposed to be called on Monday
         agenda ""
         (
          (org-agenda-start-day "-1d")
          ;; (org-agenda-span 8)
          (org-agenda-span 'week)
          (org-agenda-start-with-archives-mode t)
          (org-agenda-skip-archived-trees nil)
          (org-export-with-archived-trees t)
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-skip-scheduled-if-done t)
          (org-agenda-hide-tags-regexp ".*")
          (org-agenda-start-on-weekday 1)
          (org-agenda-use-time-grid nil)
          (org-agenda-include-deadlines nil)
          (org-agenda-archives-mode t)
          ;; (org-agenda-start-with-log-mode '(closed clock))
          (org-agenda-start-with-log-mode 'only)
          (org-agenda-log-mode-items '(closed clock))
          (org-agenda-skip-function #'org-agenda-not-done)))
        ("f" "Fortnite review"
         agenda ""
         ((org-agenda-start-day "-7d") ; don't go more than 2 weeks back
          (org-agenda-span 'fortnight)
          (org-agenda-start-with-archives-mode t)
          (org-agenda-archives-mode t)
          (org-agenda-skip-archived-trees nil)
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-skip-scheduled-if-done t)
          (org-agenda-use-time-grid nil)
          ;; (with-files t)
          ;; (org-agenda-span 21)
          (org-agenda-start-on-weekday 1) ; start on monday
          ;; (org-agenda-start-on-weekday nil)
          (org-export-with-archived-trees t)
          ;; (org-agenda-start-with-log-mode '(closed clock))
          (org-agenda-start-with-log-mode 'only)
          (org-agenda-log-mode-items '(closed clock))
          ;; (org-agenda-skip-function #'org-agenda-not-done)
          ))
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

;; (defun ak/export-weekly-done ()
;;   (save-window-excursion
;;     (org-agenda nil "E")
;;     (org-batch-agenda "E")
;;     (org-batch-agenda-csv "E")
;;     (org-store-agenda-views )))

;; Journal
;; (require 'org-journal)
;; (after! org-journal
;; (setq org-journal-file-format "journal-%Y%m%d.org"
;;       org-journal-file-type 'yearly
;;       org-journal-enable-agenda-integration t)
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
(defun ak/add-roam-tags ()
  "Iterates roam files without FILETAGS and asks for tags."
  ;; TODO refine the list of tags.
  (interactive)
  (save-window-excursion
    (dolist-with-progress-reporter (file (directory-files org-roam-directory t ".*\.org" t))
        "Adding tags to roam files..."
      (find-file file)
      (goto-char (point-min))
      (unless (or (cdr (car (org-collect-keywords '("FILETAGS")))) (not (search-forward "#+" nil t)))
        (end-of-line)
        (newline)
        (insert "#+FILETAGS: ")
        (while-let ((input (s-trim (completing-read "Tags? " (-filter #'stringp (mapcar 'car org-tag-alist )))))
                    (continue (not (s-equals? "" input))))
          (insert ":")
          (insert input)
          )
        (insert ":")
        (save-buffer)
        (kill-current-buffer)
        ))))

;; Roam additions
(require 'org-roam-timestamps)
(setq org-roam-timestamps-remember-timestamps t)
(org-roam-timestamps-mode)
(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))


;; Org src blocks
;; (after! 'org-tempo
(require 'org-tempo) ;; This is needed as of Org 9.2
(add-to-list 'org-structure-template-alist '("t" . "src shell"))
(add-to-list 'org-structure-template-alist '("cs" . "src csharp"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("ru" . "src rust"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("y" . "src yaml"))
(add-to-list 'org-structure-template-alist '("j" . "src json"))
(add-to-list 'org-structure-template-alist '("x" . "src xml"))
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

(map! :map org-mode-map
      :localleader
      ">" #'org-insert-subheading
      "<" #'org-insert-heading)

(after! org-noter
  (org-noter-enable-org-roam-integration)
  (setq org-noter-arrow-delay 0.05
        org-noter-separate-notes-from-heading nil
        org-noter-arrow-background-color "black")
  (map! :map org-noter-doc-mode-map
        "M-S-i" #'org-noter-insert-note
        "C-M-i" #'org-noter-insert-precise-note
        "C-q" #'org-noter-kill-session)
  (map! :map org-noter-notes-mode-map
        "M-S-i" #'org-noter-insert-note
        "C-M-i" #'org-noter-insert-precise-note
        "C-q" #'org-noter-kill-session)
  (defun my/org-noter-enter-insert-mode (&rest args) (evil-insert 0))
  (require 'org-noter)
  (advice-add 'org-noter-insert-note :after #'my/org-noter-enter-insert-mode)
  ;; (advice-add :before #'org-noter-kill-session)
  ;; (toggle-window-dedicated)
  )
(map! :map org-mode-map :localleader "N" #'org-noter)

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

(require 'org-auto-tangle)
(add-hook 'org-mode-hook 'org-auto-tangle-mode)

(defun my/org-capture-kill-terminal ()
  (remove-hook 'org-capture-after-finalize-hook #'my/org-capture-kill-terminal)
  (save-buffers-kill-terminal t))

(defun my/org-terminal-capture ()
  (add-hook 'org-capture-after-finalize-hook #'my/org-capture-kill-terminal)
  (org-capture))
