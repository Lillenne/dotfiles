;;; init.el -*- lexical-binding: t; -*-

;;TODO check out grip mode +grip flag for md mode https://github.com/seagle0128/grip-mode
                                        ;(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(setq gc-cons-threshold 2000000) ; increase gc threshold to improve performance
(require 'load-env-vars)
(load-env-vars "/home/aus/.dotvars")
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 20))
(setq doom-theme 'doom-one)
(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;;start fullscreen
(setq display-line-numbers-type 'relative)
(setq find-file-visit-truename t)
(setq user-full-name (getenv "NAME"))

(load! "org.el")
(load! "jupyter.el")
(load! "calendar.el")
(load! "timeblock.el")
(require 'todoist)
(setq todoist-token (getenv "TODOIST_TOKEN"))
(load! "todoist.el")
;; (setq todoist-show-all t)
(defvar ak/use-mu4e t)
(when ak/use-mu4e (load! "mu4e.el"))
(defvar ak/use-lsp-bridge nil)
(when ak/use-lsp-bridge (load! "lsp-bridge.el"))
(defvar ak/use-ellama t)
(when ak/use-ellama (load! "ellama.el"))
(defvar ak/use-lsp-mode t)
(when ak/use-lsp-mode (load! "debug.el")(load! "company.el"))
(load! "evil.el")


(defun ak/is-minibuf () (minibuffer-window-active-p (current-buffer)))
(defun ak/is-only-window () (equal (length (window-list-1)) 1))

(after! projectile
  (require 'f)
  (defun my-projectile-ignore-project (project-root)
    (or (f-descendant-of? project-root (expand-file-name "/home/aus/.rustup"))
        (f-descendant-of? project-root "/home/aus/.cargo")
        (doom-project-ignored-p project-root)))
  (setq projectile-ignored-project-function #'my-projectile-ignore-project)
  (add-to-list 'projectile-globally-ignored-file-suffixes ".onnx")
  )

(defun ak/copy-full-path-dired () (interactive)
       (kill-new (expand-file-name (dired-copy-filename-as-kill))))
(defun ak/copy-full-path () (interactive)
       (kill-new (expand-file-name (buffer-file-name))))

(load! "banner.el")
(load! "bindings.el")
(load! "polish.el")

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
