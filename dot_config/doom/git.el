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

(defun my/magit-chezmoi ()
  (interactive)
  (magit-status (expand-file-name "~/.local/share/chezmoi/")))
(map! :desc "Dotfiles" :leader "g d" #'my/magit-chezmoi)

(defun my/chezmoi-edit (&optional file)
  "Expects editor to be emacsclient [-r]."
  (call-process-shell-command (concat "chezmoi edit --apply --force " (expand-file-name file) "&")))
(defun my/find-chezmoi-only-file (&optional file)
  (interactive (list (read-file-name "File: " (expand-file-name "~/.local/share/chezmoi/"))))
  (find-file file))
(defun my/find-chezmoi-file (&optional file)
  (interactive (list (read-file-name "File: " (expand-file-name "~/"))))
  (my/chezmoi-edit file)
  (run-at-time 4 nil #'add-hook 'kill-buffer-hook #'server-edit nil t))
(defun my/find-chezmoi-doom-file (&optional file)
  (interactive (list (read-file-name "File: " (expand-file-name "~/.config/doom/"))))
  (my/chezmoi-edit file)
  (run-at-time 4 nil #'add-hook 'kill-buffer-hook #'server-edit nil t)) ; few seconds to open the file
(map! :desc "Chezmoi files" :leader "f Z" #'my/find-chezmoi-only-file)
(map! :desc "Chezmoi files" :leader "f z" #'my/find-chezmoi-file)
(map! :desc "Chezmoi files" :leader "f p" #'my/find-chezmoi-doom-file)

(defvar my/org-folded-default org-startup-folded)
(defun my/set-org-folded () (setq org-startup-folded nil))
(defun my/set-org-not-folded () (setq org-startup-folded 'my/org-folded-default))
(add-hook 'ediff-mode-hook #'my/set-org-folded)
(add-hook 'ediff-quit-hook #'my/set-org-not-folded)
