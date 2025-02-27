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
