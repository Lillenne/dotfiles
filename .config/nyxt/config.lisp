;; Doesn't work -- opens a second window
;; (defmethod nyxt::startup ((browser browser) urls)
;;   "Make a blank buffer."
;;   (window-make browser)
;;   (let ((window (current-window)))
;;     (window-set-buffer window (make-buffer :url (quri:uri "about:blank")))
;;     (toggle-fullscreen window)))

(define-configuration :web-buffer
    ((default-modes (append (list :vi-normal-mode) %slot-value%))))

;; (define-configuration prompt-buffer
;;     ((default-modes (append '(vi-insert-mode) %slot-default%))))

(define-configuration :prompt-buffer
    ((default-modes (append (list :vi-insert-mode) %slot-value%))))

;; (define-configuration (web-buffer nosave-buffer)
;;     ((default-modes (append
;;                      '(auto-mode
;;                        blocker-mode
;;                        force-https-mode
;;                        noimage-mode
;;                        noscript-mode
;;                        proxy-mode
;;                        reduce-tracking-mode)
;;                      %slot-default%))))

;;(in-package #:nyxt-user)

;; (define-configuration nx-dark-reader:dark-reader-mode
;;     ((nxdr:selection-color "#CD5C5C")
;;      (nxdr:background-color "black")
;;      (nxdr:text-color "white")
;;      (nxdr:grayscale 50)
;;      (nxdr:contrast 100)
;;      (nxdr:brightness 100)))

;; (define-configuration :web-buffer
;;     ((default-modes `(nx-dark-reader:dark-reader-mode ,@%slot-value%))))

;; (define-configuration browser
;;     ;; Enable --remote --eval code evaluation.
;;     ((remote-execution-p t)
;;      (external-editor-program
;;       (list "emacsclient" "-cn" "-a" "emacs" ))))

;; (define-configuration :browser
;;     "Set new buffer URL (a.k.a. start page, new tab page)."
;;   ((default-new-buffer-url (quri:uri "nyxt:nyxt/mode/repl:repl"))))

;; (define-configuration :nosave-buffer
;;     "Enable proxy in nosave (private, incognito) buffers."
;;   ((default-modes `(:proxy-mode ,@*web-buffer-modes* ,@%slot-value%))))

;; (define-command-global open-in-nosave-buffer ()
;;   "Make a new nosave buffer with URL at point."
;;   (let ((url (url-at-point (current-buffer))))
;;     (make-nosave-buffer :url url)))

;; (ffi-add-context-menu-command
;;  (lambda ()
;;    (when (url-at-point (current-buffer))
;;      (make-nosave-buffer :url (url-at-point (current-buffer)))))
;;  "Open Link in New Nosave Buffer")

;; (define-configuration :document-mode
;;     "Add basic keybindings."
;;   ((keyscheme-map
;;     (keymaps:define-keyscheme-map
;;         "custom" (list :import %slot-value%)
;;       ;; If you want to have VI bindings overriden, just use
;;       ;; `scheme:vi-normal' or `scheme:vi-insert' instead of
;;       ;; `scheme:emacs'.
;;       nyxt/keyscheme:vi-normal
;;       (list "C-c p" 'copy-password
;;             "M-x" 'eval-expression
;;             "/" :search-buffer
;;             "C-A" (lambda-command small-a-with-acute ()
;;                                   (ffi-buffer-paste (current-buffer) "á"))
;;             "C-I" (lambda-command small-i-diaeresis ()
;;                                   (ffi-buffer-paste (current-buffer) "ï"))
;;             )))))


;; (define-configuration :status-buffer
;;   "Display modes as short glyphs."
;;   ((glyph-mode-presentation-p t)))

;; (define-configuration :force-https-mode ((glyph "ϕ")))
;; (define-configuration :user-script-mode ((glyph "u")))
;; (define-configuration :blocker-mode ((glyph "β")))
;; (define-configuration :proxy-mode ((glyph "π")))
;; (define-configuration :reduce-tracking-mode ((glyph "τ")))
;; (define-configuration :certificate-exception-mode ((glyph "χ")))
;; (define-configuration :style-mode ((glyph "ϕ")))
;; (define-configuration :cruise-control-mode ((glyph "σ")))

;; (define-configuration status-buffer
;;   "Hide most of the status elements but URL and modes."
;;   ((style (str:concat
;;            %slot-value%
;;            (theme:themed-css (theme *browser*)
;; 	     `("#controls,#tabs"
;; 	       :display none !important))))))

;; (defmethod format-status-load-status ((status status-buffer))
;;   "A fancier load status."
;;   (spinneret:with-html-string
;;    (:span (if (and (current-buffer)
;;                    (web-buffer-p (current-buffer)))
;;               (case (slot-value (current-buffer) 'nyxt::status)
;;                     (:unloaded "∅")
;;                     (:loading "∞")
;;                     (:finished ""))
;;             ""))))

;; This automatically darkens WebKit-native interfaces and sends the
;; "prefers-color-scheme: dark" to all the supporting websites.
(setf (uiop:getenv "GTK_THEME") "Adwaita:dark")
