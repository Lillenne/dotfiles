;;; debug.el -*- lexical-binding: t; -*-
;;(require 'mu4e)
(require 'smtpmail)
(defvar ak/email-address (getenv "EMAIL_ADDRESS"))
(setq user-mail-address ak/email-address)

(set-email-account! "pm"
                '((mu4e-sent-folder       . "/Sent")
                (mu4e-drafts-folder     . "/Drafts")
                (mu4e-trash-folder      . "/Trash")
                (mu4e-refile-folder     . "/All Mail")
                (user-full-name . user-full-name)
                (smtpmail-smtp-user     . ak/email-address)
                (user-mail-address . ak/email-address))
                t)

(setq   mu4e-get-mail-command "mbsync -a"
        mu4e-change-filenames-when-moving t   ; needed for mbsync
        mu4e-compose-format-flowed t
        mu4e-sent-messages-behavior 'delete   ; handled by imap
        mu4e-update-interval 60)              ; update every 1 minute

;; Send mail
(setq message-send-mail-function 'smtpmail-send-it
smtpmail-auth-credentials "~/.authinfo.gpg"
smtpmail-smtp-server "127.0.0.1"
smtpmail-stream-type 'starttls
smtpmail-smtp-service 1025)

;(add-to-list 'gnutls-trustfiles (expand-file-name "~/.config/protonmail/bridge-v3/cert.pem"))

;; TODO gmail context?
;; (setq smtpmail-servers-requiring-authorization ".*")
;; (setq +mu4e-gmail-accounts '((ak/email-address. "/")))
;; ;;don't need to run cleanup after indexing for gmail
;; (setq mu4e-index-cleanup nil
;; ;; because gmail uses labels as folders we can use lazy check since
;; ;; messages don't really "move"
;; mu4e-index-lazy-check t)
(setq mu4e-maildir-shortcuts
        '(("/Inbox"   . ?i)
        ("/Sent"      . ?s)
        ("/Trash"     . ?t)
        ("/Drafts"    . ?d)
        ("/All Mail"  . ?a)))
(setq shr-color-visible-luminance-min 80)
