;;; timeblock.el -*- lexical-binding: t; -*-

;; (setq org-hyperscheduler-inbox-file "/home/aus/org/todos.org")
;; (setq org-hyperscheduler-readonly-mode nil)

                                        ; todo adjust org-timeblock-mode-map, interactions with evil mode
(map! :leader "o s s" #'org-timeblock)
(map! :leader "o s r" #'org-timeblock-redraw-buffers)
(map! :leader "o s q" #'org-timeblock-quit)
(map! :leader "o s +" #'org-timeblock-new-task)
(setq org-timeblock-inbox-file "/home/aus/org/todos.org")
(setq org-timeblock-span 1)
;; https://github.com/ichernyshovvv/org-timeblock/issues/21
(use-package org-timeblock
  :hook ((org-timeblock-mode org-timeblock-list-mode) . my/org-timeblock-evil-map)
  :config
  (add-hook 'org-timeblock-mode-hook (lambda () (turn-off-evil-snipe-mode))) ; turn off conflicting keybind
  ;; :straight (org-timeblock :type git
  ;;       		   :host github
  ;;       		   :repo "ichernyshovvv/org-timeblock")
  :init
                                        ; note, not enabled when switching back to buffer
  (defun my/org-timeblock-evil-map ()
    "Set the keybindings for 'org-timeblock' to be compatible with evil mode"
    (evil-define-key 'normal org-timeblock-mode-map
      "+" 'org-timeblock-new-task
      "j" 'org-timeblock-forward-block
      "l" 'org-timeblock-forward-column
      "h" 'org-timeblock-backward-column
      "k" 'org-timeblock-backward-block
      (kbd "C-<down>") 'org-timeblock-day-later
      (kbd "C-<up>") 'org-timeblock-day-earlier
      (kbd "RET") 'org-timeblock-goto
      (kbd "TAB") 'org-timeblock-goto-other-window ; not-working
      "d" 'org-timeblock-set-duration
      "r" 'org-timeblock-redraw-buffers
      "gd" 'org-timeblock-jump-to-day
      "q" 'org-timeblock-quit
      "s" 'org-timeblock-schedule ; not workig
      "t" 'org-timeblock-toggle-timeblock-list
      "v" 'org-timeblock-switch-scaling
      "V" 'org-timeblock-switch-view) ; not working
    (evil-define-key 'normal org-timeblock-list-mode-map
      "+" 'org-timeblock-new-task
      "j" 'org-timeblock-list-next-line
      "k" 'org-timeblock-list-previous-line
      (kbd "C-<down>") 'org-timeblock-day-later
      (kbd "C-<up>") 'org-timeblock-day-earlier
      (kbd "C-s") 'org-timeblock-list-save
      (kbd "M-<down>") 'org-timeblock-list-drag-line-forward
      (kbd "M-<up>") 'org-timeblock-list-drag-line-backward
      (kbd "RET") 'org-timeblock-list-goto
      (kbd "TAB") 'org-timeblock-list-goto-other-window
      "S" 'org-timeblock-list-toggle-sort-function
      "d" 'org-timeblock-list-set-duration
      "r" 'org-timeblock-redraw-buffers
      "gd" 'org-timeblock-jump-to-day
      "q" 'org-timeblock-quit
      "s" 'org-timeblock-list-schedule
      "t" 'org-timeblock-list-toggle-timeblock
      "v" 'org-timeblock-switch-scaling
      "V" 'org-timeblock-switch-view)))
