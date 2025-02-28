;;; git.el -*- lexical-binding: t; -*-

;; (use-package forge
;;   :after magit)

;;   https://github.com/magit/magit/issues/460
(defun my/magit-process-environment (env)
  "Detect and set git -bare repo env vars when in tracked dotfile directories."
  (let* ((default (file-name-as-directory (expand-file-name default-directory)))
         (git-dir (expand-file-name "~/.dotfiles/"))
         (work-tree (expand-file-name "~/"))
         (dotfile-dirs
          (-map (apply-partially 'concat work-tree)
                (-uniq (-keep #'file-name-directory (split-string (shell-command-to-string
                                                                   (format "/usr/bin/git --git-dir=%s --work-tree=%s ls-tree --full-tree --name-only -r HEAD"
                                                                           git-dir work-tree))))))))
    (push work-tree dotfile-dirs)
    (when (member default dotfile-dirs)
      (push (format "GIT_WORK_TREE=%s" work-tree) env)
      (push (format "GIT_DIR=%s" git-dir) env)))
  env)

(advice-add 'magit-process-environment
            :filter-return #'my/magit-process-environment)
;; (setq transient-display-buffer-action '(display-buffer-in-side-window
;;                                         (side . bottom)
;;                                         (dedicated . t)
;;                                         (inhibit-same-window . t)))

(defun my/server-edit-kill ()
  (add-hook 'kill-buffer-hook #'server-edit nil t))
(add-hook 'chezmoi-mode-hook #'my/server-edit-kill nil t)
(defun my/chezmoi-edit (file)
  "Expects editor to be emacsclient."
  (call-process-shell-command (concat "chezmoi edit --apply --force " (expand-file-name file) "&")))
(defun my/find-chezmoi-only-file (&optional file)
  (interactive (list (read-file-name "File: " (expand-file-name "~/.local/share/chezmoi/"))))
  (find-file file))
(defun my/find-chezmoi-file (&optional file)
  (interactive (list (list (chezmoi--completing-read "Select a dotfile to edit: "
                                                     (chezmoi-managed-files)
                                                     'project-file))))
  (my/chezmoi-edit file)
  (run-at-time 4 nil #'add-hook 'kill-buffer-hook #'server-edit nil t))
(defun my/find-chezmoi-doom-file (&optional file)
  (interactive (list (read-file-name "File: " (expand-file-name "~/.config/doom/"))))
  (my/chezmoi-edit file)
  (run-at-time 4 nil #'add-hook 'kill-buffer-hook #'server-edit nil t)) ; few seconds to open the file
;; (map! :desc "Chezmoi files" :leader "f Z" #'my/find-chezmoi-only-file)
;; (map! :desc "Chezmoi files" :leader "f z" #'my/find-chezmoi-file)
;; (map! :desc "Chezmoi files" :leader "f p" #'my/find-chezmoi-doom-file)

(require 'org)
(defvar my/org-folded-default 'org-startup-folded)
(defun my/set-org-folded () (setq org-startup-folded nil))
(defun my/set-org-not-folded () (setq org-startup-folded 'my/org-folded-default))
(add-hook 'ediff-mode-hook #'my/set-org-folded)
(add-hook 'ediff-quit-hook #'my/set-org-not-folded)


(require 'chezmoi)
(setq-default chezmoi-template-display-p nil)   ;; Display template values in all source buffers when non-nil.
;; (setq chezmoi-template-display-p t)           ;; Display template values in current buffer.

;;; completion for chezmoi toml
;; (require 'chezmoi-cape)
;; (add-to-list 'completion-at-point-functions #'chezmoi-capf) ;;undefined cape--table-with-properties. Out of date?
;; (add-hook 'org-babel-post-tangle-hook #'chezmoi-write))

(require 'chezmoi-magit)
(require 'chezmoi-ediff)
(require 'chezmoi-age)
(require 'chezmoi-dired)
(setq age-default-identity ""
      age-default-recipient "")
(map! :desc "Chezmoi find" :leader "f p" #'chezmoi-find)
(map! :desc "Chezmoi diff" :leader "g d d" #'chezmoi-ediff)
(map! :desc "Chezmoi sync" :leader "g d s" #'chezmoi-sync-files)
(map! :desc "Chezmoi status" :leader "g d g" #'chezmoi-magit-status)
(map! :desc "Chezmoi template display" :leader "g d t" #'chezmoi-template-buffer-display)
(map! :desc "Chezmoi add marked"
      :map dired-mode-map
      :localleader "."
      #'chezmoi-dired-add-marked-files)
