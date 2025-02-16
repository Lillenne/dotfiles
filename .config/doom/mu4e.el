;;; debug.el -*- lexical-binding: t; -*-

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
(require 'smtpmail)
(require 'mu4e)
(require 'org)
(setq +org-capture-emails-file "todo.org")
(defvar ak/email-address (getenv "EMAIL_ADDRESS"))
(defvar ak/business-email-address (getenv "BUSINESS_EMAIL_ADDRESS"))
(setq mu4e-split-view 'vertical
      mu4e-headers-visible-columns 120)

(set-email-account! "aus-pm"
                    `((mu4e-sent-folder . "/aus-pm/Sent")
                      (mu4e-drafts-folder . "/aus-pm/Drafts")
                      (mu4e-trash-folder  . "/aus-pm/Trash")
                      (mu4e-refile-folder . "/aus-pm/Archive")
                      (smtpmail-smtp-user . ,ak/email-address)
                      (user-mail-address . ,ak/email-address))
                    t)
(set-email-account! "aus-pix"
                    `((mu4e-sent-folder . "/aus-pix/Sent")
                      (mu4e-drafts-folder . "/aus-pix/Drafts")
                      (mu4e-trash-folder  . "/aus-pix/Trash")
                      (mu4e-refile-folder . "/aus-pix/Archive")
                      (smtpmail-smtp-user . ,ak/business-email-address)
                      (user-mail-address . ,ak/business-email-address))
                    t)

;; https://github.com/djcb/mu/issues/1136
(setf (alist-get 'trash mu4e-marks)
      (list :char '("d" . "▼")
            :prompt "dtrash"
            :dyn-target (lambda (target msg)
                          (mu4e-get-trash-folder msg))
            :action (lambda (docid msg target)
                      ;; Here's the main difference to the regular trash mark,
                      ;; no +T before -N so the message is not marked as
                      ;; IMAP-deleted:
                      (mu4e--server-move docid (mu4e--mark-check-target target) "-N"))))

;; Mark as read and move to spam -- not working?
;; https://gist.github.com/Mic92/d455715242c8909cc8302aadd4745fcf
;; (defvar mu4e-spam-folder "~/.pmail/Spam")
;; (add-to-list 'mu4e-marks
;;              '(spam
;;                :char       "X"
;;                :prompt     "Spam"
;;                :show-target (lambda (target) mu4e-spam-folder)
;;                :action      (lambda (docid msg target)
;;                               (mu4e~proc-move docid mu4e-spam-folder "+S-u-N"))))
;; (mu4e~headers-defun-mark-for spam)
;; (define-key mu4e-headers-mode-map (kbd "X") 'mu4e-headers-mark-for-spam)


(setq   mu4e-get-mail-command "mbsync -a"
        mu4e-change-filenames-when-moving t   ; needed for mbsync
        mu4e-compose-format-flowed t
        mu4e-sent-messages-behavior 'trash   ; handled by imap
        mu4e-refile-folder "/Archive"
        mu4e-update-interval 60)              ; update every 1 minute

;; Send mail
(setq message-send-mail-function 'smtpmail-send-it
      message-cite-function #'mu4e-message-cite-nothing
      smtpmail-auth-credentials "~/.authinfo.gpg"
      smtpmail-smtp-server "127.0.0.1"
      smtpmail-stream-type 'starttls
      smtpmail-smtp-service 1025)

;; TODO gmail context?
;; (setq smtpmail-servers-requiring-authorization ".*")
;; (setq +mu4e-gmail-accounts '((ak/email-address. "/")))
;; ;;don't need to run cleanup after indexing for gmail
;; (setq mu4e-index-cleanup nil
;; ;; because gmail uses labels as folders we can use lazy check since
;; ;; messages don't really "move"
;; mu4e-index-lazy-check t)
;; (setq mu4e-maildir-shortcuts
;;       '(("/Inbox"   . ?i)
;;         ("/Sent"      . ?s)
;;         ("/Trash"     . ?t)
;;         ("/Drafts"    . ?d)
;;         ("/Archive"    . ?r)
;;         ;; ("/All Mail"  . ?a)
;;         ))

(setq shr-color-visible-luminance-min 80)
(add-to-list 'gnutls-trustfiles (expand-file-name "~/.config/protonmail/bridge/cert.pem"))

;; TODO
(add-to-list 'mu4e-bookmarks
             '(:name "All Inboxes" :query "m:/aus-pm/INBOX or m:/aus-pix/INBOX" :key ?i))
