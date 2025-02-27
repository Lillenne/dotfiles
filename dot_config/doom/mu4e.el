;;; debug.el -*- lexical-binding: t; -*-

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
(require 'smtpmail)
(require 'mu4e)
(require 'org)
(require 's)

(setq +org-capture-emails-file "todo.org"
      mu4e-headers-visible-columns 120
      mu4e-get-mail-command "mbsync -a"
      mu4e-change-filenames-when-moving t   ; needed for mbsync
      mu4e-compose-format-flowed t
      mu4e-sent-messages-behavior 'trash   ; handled by imap
      mu4e-refile-folder "/Archive"
      mu4e-update-interval 60              ; update every 1 minute
      message-send-mail-function 'smtpmail-send-it
      message-cite-function #'mu4e-message-cite-nothing
      smtpmail-auth-credentials "~/.authinfo.gpg"
      smtpmail-stream-type 'starttls
      smtpmail-smtp-server "127.0.0.1"
      smtpmail-smtp-service 1025
      mu4e-attachment-dir "~/mail/downloads/")

(defun my/set-email-account (name folder env-var &optional user-name)
  (let ((addr (getenv env-var)))
    (unless (s-blank? addr)
      (set-email-account! name
                          `((mu4e-sent-folder . ,(expand-file-name "Sent" folder))
                            (mu4e-drafts-folder . ,(expand-file-name "Drafts" folder))
                            (mu4e-trash-folder  . ,(expand-file-name "Trash" folder))
                            (mu4e-refile-folder . ,(expand-file-name "Archive" folder))
                            (smtpmail-smtp-user . ,addr)
                            (user-mail-address . ,addr)
                            (user-full-name . ,(if user-name user-name user-full-name)))
                          t))))

(add-hook 'my/config-loaded-hook
          (lambda ()
            (my/set-email-account "Pixalyzer" "/pix" "P_EMAIL_ADDRESS")
            (my/set-email-account "Shopping" "/shopping" "S_EMAIL_ADDRESS" "Austin")
            (my/set-email-account "Lillenne" "/lillenne" "L_EMAIL_ADDRESS" "Lillenne")
            (my/set-email-account "Dev" "/dev" "D_EMAIL_ADDRESS")
            (my/set-email-account "Aus" "/auspm" "EMAIL_ADDRESS")))

(defvar ak/mail-folders '("/pix" "/shopping" "/lillenne" "/dev" "/auspm"))
(defun ak/mail-query (subfolder)
  (mapconcat (lambda (root-box) (s-concat "m:" root-box subfolder)) ak/mail-folders " or "))

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
;; (add-to-list 'gnutls-trustfiles (expand-file-name "~/.config/protonmail/bridge/certnas.pem"))

;; TODO
(setq mu4e-bookmarks
      `((:name "All Inboxes" :query ,(ak/mail-query "/Inbox") :key ?i)
        (:name "All Archive" :query ,(ak/mail-query "/Archive") :key ?a)
        (:name "All Sent" :query ,(ak/mail-query "/Sent") :key ?s)
        (:name "All Drafts" :query ,(ak/mail-query "/Drafts") :key ?d)
        (:name "All Trash" :query ,(ak/mail-query "/Trash") :key ?t)))
