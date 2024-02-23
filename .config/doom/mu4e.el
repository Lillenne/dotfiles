;;; debug.el -*- lexical-binding: t; -*-
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
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
