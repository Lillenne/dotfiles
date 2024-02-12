;;; init.el -*- lexical-binding: t; -*-

(setq user-full-name "Austin Kearns"
      user-mail-address "austinkearns47@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Jetbrains Mono Nerd Font" :size 20))
(setq doom-theme 'doom-one)

(setq display-line-numbers-type 'relative)

(setq org-directory "~/org/")
(setq org-roam-directory "~/org/")
(org-roam-db-autosync-mode)
(setq find-file-visit-truename t)
;;(defun ak/todo-is-done () )
;;(defun ak/tdd () (interactive) (print (ak/todo-is-done)))

;;(add-hook 'org-after-todo-state-change-hook (ak/todo-is-done))
(defun my/org-roam-copy-todo-to-today ()
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
      (org-refile nil nil (list "Tasks" today-file nil pos))) ())
        ;;(call-interactively #'org-archive-to-archive-sibling)
        )

(setq org-after-todo-state-change-hook nil)

(add-hook 'org-after-todo-state-change-hook
             (lambda ()
               (when (or (equal org-state "[X]") (equal org-state "DONE"))
                 (my/org-roam-copy-todo-to-today))))
;; (add-to-list 'org-after-todo-state-change-hook
;;              (lambda ()
;;                (when (or (equal org-state "[X]") (equal org-state "DONE"))
;;                  (my/org-roam-copy-todo-to-today))))
;; Set depth to 95 (high, max 100), as it deletes the note & stuff shouldn't be coming after
(add-hook 'org-after-todo-state-change-hook
          (lambda ()
            (when (and (or (equal org-state "[X]") (equal org-state "DONE"))
                       (equal (+org-capture-todo-file) (buffer-file-name)))
                       (call-interactively #'org-archive-to-archive-sibling))
                       (save-buffer))
          95 nil)

;; replace the todo template
;; complete w/ rest of templates
(setq org-capture-templates (cons '("t" "Personal todo" entry (file+headline +org-capture-todo-file "Inbox") "* TODO %?\n%i\n%a" :prepend t)
                             (cons '("i" "Personal todo w/o link" entry (file+headline +org-capture-todo-file "Inbox") "* TODO %?" :prepend t)
                                (cdr org-capture-templates))))

;;start fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-director')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

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

;; mu4e config
(defvar my-use-mu4e)
(setq my-use-mu4e nil)
(when my-use-mu4e
  ;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
  (set-email-account! "austin"
                      '((mu4e-sent-folder       . "/[Gmail]/Sent Mail")
                        (mu4e-drafts-folder     . "/[Gmail]/Drafts")
                        (mu4e-trash-folder      . "/[Gmail]/Trash")
                        (mu4e-refile-folder     . "/[Gmail]/All Mail")
                        (smtpmail-smtp-user     . "austinkearns47@gmail.com")
                        (user-full-name . "Austin Kearns")
                        (mu4e-compose-signature . "---\nAustin Kearns"))
                      t)
  (require 'smtpmail)
  (setq message-send-mail-function 'smtpmail-send-it
        starttls-use-gnutls t
        ;; smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
        ;; smtpmail-auth-credentials
        ;;   '(("smtp.gmail.com" 587 "austinkearns47@gmail.com" nil))
        ;;smtpmail-default-smtp-server "smtp.gmail.com"
        smtpmail-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 587)
  (setq smtpmail-servers-requiring-authorization ".*")
  (setq mu4e-compose-format-flowed t)
  (setq mu4e-sent-messages-behavior 'delete)
  (setq +mu4e-gmail-accounts '(("austinkearns47@gmail.com" . "/")))
  ;;don't need to run cleanup after indexing for gmail
  (setq mu4e-index-cleanup nil
        ;; because gmail uses labels as folders we can use lazy check since
        ;; messages don't really "move"
        mu4e-index-lazy-check t)
  (setq mu4e-maildir-shortcuts
        '(("/Inbox"             . ?i)
          ("/[Gmail]/Sent Mail" . ?s)
          ("/[Gmail]/Trash"     . ?t)
          ("/[Gmail]/Drafts"    . ?d)
          ("/[Gmail]/All Mail"  . ?a)))

  (setq mu4e-change-filenames-when-moving t)
  (setq mu4e-update-interval (* 3 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (mu4e t)
  )

;;(company-quickhelp-mode)
;;(setq company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend))
;;(setq company-selection-wrap-around t)
(setq company-minimum-prefix-length 1)
(setq company-idle-delay 0.25)
;;(setq company-require-match nil)
;;(setq company-require-match t)

(with-eval-after-load 'company
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "<backtab>") #'company-quickhelp-manual-begin)
  )

;; Do i want this off?
;;(setq electric-pair-open-newline-between-pairs t)

;; (defun electric-pair-brace-fixup ()
;;   (when (and electric-pair-mode
;;              (if (functionp electric-pair-open-newline-between-pairs)
;;                  (funcall electric-pair-open-newline-between-pairs)
;;                electric-pair-open-newline-between-pairs)
;;              (eq last-command-event ?\{)
;;              (= ?\{ (char-before)) (= ?\} (char-after)))
;;     (newline nil t)))

;; (advice-add 'electric-pair-post-self-insert-function :after
;;             #'electric-pair-brace-fixup)


(setq org-log-done 'time)
(setq org-roam-v2-ack t)

;; (require 'web-mode)
;; (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.razor?\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.cshtml?\\'" . web-mode))
;; (setq web-mode-engines-alist
;;       '(
;;         ("razor"    . "\\.cshtml\\'")
;;         ("razor"    . "\\.razor\\'")
;;         ("blade"  . "\\.blade\\.")
;;         )
;;       )

(defun vterm-vsplit () (interactive)
       (split-window-horizontally)
       (other-window 1)
       (+vterm/here default-directory))
(map! :leader "o v" 'vterm-vsplit)
(map! :leader "d" '+workspace/close-window-or-workspace)
(map! :leader "f o" 'consult-recent-file)
(map! "C-/" 'comment-dwim)
(map! :leader "f O" 'find-file-other-window)
(defun ak/goto-todo () (interactive) (find-file (+org-capture-todo-file)))
(map! :leader "f t" 'ak/goto-todo)

(require 'evil-owl)
(setq evil-owl-max-string-length 500)
(add-to-list 'display-buffer-alist
             '("*evil-owl*"
               (display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.3)))
(evil-owl-mode)

(use-package evil-snipe
  :config
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  (setq evil-snipe-use-vim-sneak-bindings t)
  (setq evil-snipe-scope 'buffer)
  (setq evil-snipe-auto-scroll t)
  (setq evil-snipe-use-vim-sneak-bindings t))

(use-package evil-quickscope
  :config (global-evil-quickscope-always-mode 1))

(defvar my-load-debug nil)
;;(setq my-load-debug t)
(when my-load-debug (load! debug.el))

(eval-after-load 'company
  '(define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin))

(setq org-link-descriptive nil)

(evil-visual-mark-mode)

(require 'evil-replace-with-register)
;; change default key bindings (if you want) HERE
;; (setq evil-replace-with-register-key (kbd "gr"))
(evil-replace-with-register-install)


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
