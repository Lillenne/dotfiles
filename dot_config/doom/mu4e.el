;;; debug.el -*- lexical-binding: t; -*-

(when my/is-main-pc
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
  (require 'smtpmail)
  (require 'mu4e)
  (require 'org)
  (require 's)
  (setq +org-capture-emails-file (expand-file-name "todo.org" org-directory)
        mu4e-split-view 'horizontal ;; vertical not working?
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
        mu4e-sent-folder "/auspm/Sent"
        mu4e-drafts-folder "/auspm/Drafts"
        mu4e-trash-folder "/auspm/Trash"
        mu4e-refile-folder "/auspm/Archive"
        smtpmail-smtp-server "127.0.0.1"
        smtpmail-smtp-service 1025
        mu4e-attachment-dir "~/mail/downloads/")

  (defun my/create-mu-context (label addr letvars &optional default-p)
    (after! mu4e
      ;; remove existing context with same label
      (setq mu4e-contexts
            (cl-loop for context in mu4e-contexts
                     unless (string= (mu4e-context-name context) label)
                     collect context))
      (let ((context (make-mu4e-context
                      :name label
                      :enter-func
                      (lambda () (mu4e-message "Switched to %s" label))
                      :leave-func
                      (lambda () (setq +mu4e-personal-addresses nil))
                      :match-func
                      (lambda (msg)
                        (when msg (mu4e-message-contact-field-matches msg :to addr)))
                      :vars letvars)))
        (add-to-list 'mu4e-contexts context (not default-p))
        context)))

  (defun my/set-email-account (name env-var &optional user-name default)
    (let ((addr (getenv env-var)))
      (unless (s-blank? addr)
        (my/create-mu-context name
                              addr
                              `((smtpmail-smtp-user . ,addr)
                                (user-mail-address . ,addr)
                                (user-full-name . ,(or user-name user-full-name)))
                              default))))


  (add-hook 'my/config-loaded-hook
            (lambda ()
              (setq user-mail-address (getenv "EMAIL_ADDRESS"))
              (my/set-email-account "Pixalyzer" "P_EMAIL_ADDRESS" "Austin")
              (my/set-email-account "Pix-all" "DOMAIN1_EMAIL_ADDRESS" "Austin")
              (my/set-email-account "Shopping" "S_EMAIL_ADDRESS" "Austin")
              (my/set-email-account "Lillenne" "L_EMAIL_ADDRESS" "Lillenne")
              (my/set-email-account "Dev" "D_EMAIL_ADDRESS" "Austin")
              (my/set-email-account "Dev-all" "DOMAIN2_EMAIL_ADDRESS" "Austin")
              (my/set-email-account "Alias" "A_EMAIL_ADDRESS" "")
              (my/set-email-account "Aus" "EMAIL_ADDRESS" nil t)))

  ;; (defvar ak/mail-folders '("/pix" "/shopping" "/lillenne" "/dev" "/auspm" "/alias"))
  ;; (defun ak/mail-query (subfolder)
  ;;   (mapconcat (lambda (root-box) (s-concat "m:" root-box subfolder)) ak/mail-folders " or "))

  ;; List of marks lifted from https://github.com/djcb/mu/blob/a8fac834d3919bb8d6657e0bffbdae1b1eccfbef/mu4e/mu4e-headers.el
  (setq
   mu4e-headers-draft-mark     '("D" . "📬") ;💈📥
   mu4e-headers-flagged-mark   '("F" . "❗") ; 📍
   mu4e-headers-new-mark       '("N" . "📨") ; 🔥
   mu4e-headers-passed-mark    '("P" . "❯") ; 📚
   mu4e-headers-replied-mark   '("R" . "❮")
   mu4e-headers-seen-mark      '("S" . "☑")
   mu4e-headers-trashed-mark   '("T" . "🗑️") ; 💀
   mu4e-headers-attach-mark    '("a" . "📎")
   mu4e-headers-encrypted-mark '("x" . "🔒")
   mu4e-headers-signed-mark    '("s" . "🔑")
   mu4e-headers-unread-mark    '("u" . "✉️") ; ⎕
   mu4e-headers-list-mark      '("l" . "👥") ; 🔈
   mu4e-headers-personal-mark  '("p" . "🧍") ; 👨
   mu4e-headers-calendar-mark  '("c" . "📅"))

  (map! :map mu4e-)
  
  ;; https://github.com/djcb/mu/issues/1136 ; move to trash only, let server delete it later based on trash deletion rules
  (setf (alist-get 'trash mu4e-marks)
        (list :char '("d" . "🚽")
              :prompt "dtrash"
              :dyn-target (lambda (_ msg)
                            (mu4e-get-trash-folder msg))
              :action (lambda (docid _ target)
                        ;; Here's the main difference to the regular trash mark,
                        ;; no +T before -N so the message is not marked as
                        ;; IMAP-deleted:
                        ;; Also added seen and removed unread tags
                        (mu4e--server-move docid (mu4e--mark-check-target target) "+S-u-N"))))
  (setq mu4e-marks (delq (assq 'delete mu4e-marks) mu4e-marks))

  ;; https://gist.github.com/Mic92/d455715242c8909cc8302aadd4745fcf ; now uses mu4e--server-move
  ;; The flags are any of `deleted', `flagged', `new', `passed', `replied' `seen' or
  ;; `trashed', or the corresponding \"DFNPRST\" as defined in [1]. See
  (defvar mu4e-spam-folder "/auspm/Spam")
  (add-to-list 'mu4e-marks
               '(spam
                 :char       "D"
                 :prompt     "Spam"
                 :show-target (lambda (target) mu4e-spam-folder)
                 :action      (lambda (docid msg target)
                                (mu4e--server-move docid mu4e-spam-folder "+S-u-N"))))

  (mu4e~headers-defun-mark-for spam)
  ;; (map! :map mu4e-headers-mode-map "D" 'mu4e-headers-mark-for-spam)
  (defun my/browse-url-at-point (arg) ; for some reason, browse-url-at-point is opening non-urls
    (interactive "P")
    (when-let ((url (thing-at-point 'url t)))
      (browse-url-at-point arg)))
  (map! :map mu4e-headers-mode-map :n "D" #'mu4e-headers-mark-for-spam)
  (map! :map mu4e-view-mode-map :n "RET" #'my/browse-url-at-point)
  (map! :map mu4e-view-mode-map :n "<return>" #'my/browse-url-at-point)
  ;; (define-key mu4e-headers-mode-map (kbd "D") 'mu4e-headers-mark-for-spam)


  ;; Always default to reply from the account that the mail was sent to for SimpleLogin aliases.
  ;; They use the same main account credentials anyways.
  ;; (defun my/mu4e-set-account ()
  ;;   ;; based on https://stackoverflow.com/questions/48026560/mu4e-reply-from-the-correct-account
  ;;   "Set the account for composing a message."
  ;;   (when-let ((parent mu4e-compose-parent-message)
  ;;              (addr (car (cdr (car (mu4e-message-field mu4e-compose-parent-message :to))))))
  ;;     (require 's)
  ;;     (when (s-contains? "passmail.net" addr) (setq user-mail-address addr))))

  ;; (add-hook 'mu4e-compose-pre-hook 'my/mu4e-set-account)

  (setq mu4e-compose-context-policy 'ask-if-none
        mu4e-context-policy 'ask-if-none)


  (setq mu4e-maildir-shortcuts
        '(("/auspm/Inbox"   . ?i)
          ("/auspm/Sent"      . ?s)
          ("/auspm/Trash"     . ?t)
          ("/auspm/Drafts"    . ?d)
          ("/auspm/Archive"    . ?r)
          ("/auspm/Spam"    . ?S)
          ;; ("/All Mail"  . ?a)
          ))

  (setq shr-color-visible-luminance-min 25)
  (add-to-list 'gnutls-trustfiles (expand-file-name "~/.config/protonmail/bridge/cert.pem"))
  )
