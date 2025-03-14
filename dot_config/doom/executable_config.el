;;; init.el -*- lexical-binding: t; -*-

;;TODO check out grip mode +grip flag for md mode https://github.com/seagle0128/grip-mode
                                        ;(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
;; (remove-hook 'doom-first-buffer-hook #'global-flycheck-mode)
(setenv "LSP_USE_PLISTS" "true") ; remember to add this to /etc/environment or .config/emacs/early-init.el
(require 's)
(defvar my/is-main-pc (string= (s-trim (shell-command-to-string "hostname")) "dark"))
(defvar my/config-loaded-frame-delay 0.5)
(defvar my/config-loaded-hook nil "Hook run at `my/config-loaded-frame-delay' seconds after a frame has been loaded.
The hook may be delayed because some functions (e.g., gpg decryption) may need user input via emacs.")
(add-hook 'my/config-loaded-hook
          (lambda () (setq user-full-name (getenv "NAME"))))
(setq gc-cons-threshold 2000000) ; increase gc threshold to improve performance
(setq auth-sources '("~/.authinfo.gpg"))
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 20))
(setq doom-theme 'doom-one)
(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;;start fullscreen
(setq display-line-numbers-type 'relative)
(setq find-file-visit-truename t)
(setq delete-by-moving-to-trash nil)
(setq embark-confirm-act-all nil)

(setq register-use-preview t)
(kill-ring-deindent-mode)

(after! spell-fu
  (setq spell-fu-idle-delay 0.5
        ispell-personal-dictionary "~/.config/ispell/.pws")
  (setf (alist-get 'markdown-mode +spell-excluded-faces-alist)
        '(markdown-code-face
          markdown-reference-face
          markdown-link-face
          markdown-url-face
          markdown-markup-face
          markdown-html-attr-value-face
          markdown-html-attr-name-face
          markdown-html-tag-name-face)))

;; Enable when gnu repo is down  https://www.reddit.com/r/DoomEmacs/comments/1dohgxv/gitsavannahgnuorg_is_down/
;;(defadvice! straight-use-recipes-ignore-nongnu-elpa-a (fn recipe)
;;  :around #'straight-use-recipes
;;  (unless (eq 'nongnu-elpa (car recipe))
;;    (funcall fn recipe)))


;; (load! "jupyter.el")
(load! "git.el")
(load! "timeblock.el")
(load! "mu4e.el")
(when my/is-main-pc (load! "mu4e.el"))
;; (load! "calendar.el")
;; (load! "ellama.el")
(load! "debug.el")
(load! "company.el")
(load! "evil.el")
(load! "art.el")

;; (after! org
;;   :config (setq khoj-server-url "https://khoj.pixalyzer.com"
;;                 khoj-org-directories '("~/org/roam" "~/org")))

(defun ak/is-minibuf () (minibuffer-window-active-p (current-buffer)))
(defun ak/is-only-window () (equal (length (window-list-1)) 1))

;; https://github.com/doomemacs/doomemacs/issues/5876
;; (after! persp-mode
;;   (setq persp-emacsclient-init-frame-behaviour-override "main"))

(after! projectile
  (require 'f)
  (defun my-projectile-ignore-project (project-root)
    (or (f-descendant-of? project-root (expand-file-name "/home/aus/.rustup"))
        (f-descendant-of? project-root "/home/aus/.cargo")
        (doom-project-ignored-p project-root)))
  (setq projectile-ignored-project-function #'my-projectile-ignore-project)
  (add-to-list 'projectile-globally-ignored-file-suffixes ".onnx")
  ;; (map! :leader "SPC" #'(lambda () (interactive) (projectile-find-file t))) ;; Having projectile cache issues
  )

(defun ak/copy-full-path-dired ()
  (interactive)
  (kill-new (expand-file-name (dired-copy-filename-as-kill))))
(defun ak/copy-full-path ()
  (interactive)
  (kill-new (buffer-file-name (window-buffer (minibuffer-selected-window)))))

(defun name-of-the-file ()
  "Gets the name of the file the current buffer is based on."
  (interactive)
  (insert (buffer-file-name (window-buffer (minibuffer-selected-window)))))

(defun print-name-of-the-file ()
  "Gets the name of the file the current buffer is based on."
  (interactive)
  (print (buffer-file-name (window-buffer (minibuffer-selected-window)))))

(defun delete-visited-file-current-file ()
  "Delete the file visited by the current buffer."
  (interactive)
  (let* ((buffer (current-buffer))
         (filename (buffer-file-name buffer)))
    (when buffer
      (when (and filename
                 (file-exists-p filename))
        (delete-file filename))
      (kill-buffer buffer))))

(defun delete-visited-file (buffer-name)
  "Delete the file visited by the buffer named BUFFER-NAME."
  (interactive "Delete file visited by buffer ")
  (let* ((buffer (get-buffer buffer-name))
         (filename (buffer-file-name buffer)))
    (when buffer
      (when (and filename
                 (file-exists-p filename))
        (delete-file filename))
      (kill-buffer buffer))))

(load! "banner.el")
(load! "bindings.el")
(load! "org.el")
(load! "todoist.el")
(load! "polish.el")
(defvar my/config-loaded nil)
(defun my/load-config ()
  (let ((inhibit-message t))
    (require 'load-env-vars)
    (unless my/config-loaded
      (setq my/config-loaded t)
      (load-env-vars (expand-file-name "~/.dotvars.gpg")))))
(add-hook 'my/config-loaded-hook #'my/load-config -1)
(defun my/config-loaded-hook-run-fn ()
  (interactive)
  (message "Running hooks...")
  (run-hooks 'my/config-loaded-hook)
  (message "Hooks complete."))
(defun my/config-loaded-hook-run-fn-delay ()
  (run-at-time my/config-loaded-frame-delay nil #'my/config-loaded-hook-run-fn))
(add-hook 'doom-first-buffer-hook #'my/config-loaded-hook-run-fn-delay)
(defun my/config-reload ()
  (interactive)
  (setq my/config-loaded nil)
  (my/config-loaded-hook-run-fn))
(map! :desc "Config loaded hooks" :leader "h r m" #'my/config-reload)


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
