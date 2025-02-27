;;; bindings.el -*- lexical-binding: t; -*-

;; (map! :map 'override "C-i" #'better-jumper-jump-forward) ;; this bind for some reason keeps messing other stuff up?

(map! "C-c n" #'dotnet-new-dispatch)

(defun vterm-vsplit () (interactive) (split-window-horizontally) (other-window 1) (+vterm/here default-directory))
(map! :leader "o v" #'vterm-vsplit)
(map! :leader "k" #'+workspace/close-window-or-workspace)
(map! :leader "yy" #'ak/copy-full-path)
(map! :leader "YY" #'ak/copy-full-path-dired)
(map! :leader "z" #'olivetti-mode)
(setq-default olivetti-body-width .4)
(map! :m "<C-S-up>" #'shrink-window)
(map! :m "<C-S-down>" #'enlarge-window)
(map! :m "<C-S-left>" #'shrink-window-horizontally)
(map! :m "<C-S-right>" #'enlarge-window-horizontally)

;; move line up
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (previous-line 2))

;; move line down
(defun move-line-down ()
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))

;; (map! :m "<M-down>" #'move-line-down)
;; (map! :m "<M-up>" #'move-line-up)

(map! :leader "f o" #'consult-recent-file)
(map! :leader "f O" #'find-file-other-window)
(map! :leader "f w" #'consult-ripgrep)
(map! :leader "f f" #'consult-fd)
(map! :leader "f g" #'consult-git-grep)
(map! :leader "s g" #'consult-ripgrep)
(map! :leader "s G" #'consult-git-grep)
(map! :leader "O" #'projectile-find-file-other-window)
;; (map! :map 'override :leader "w" #'save-buffer)
(map! :map 'override "C-w b" #'split-window-vertically)
(map! :map 'override "C-A" #'embark-act)
(map! :map 'override "C-S" #'embark-act-all)
(map! :map 'override "M-SPC" #'doom/leader)
(map! :map 'override "C-S-h" #'+evil/window-move-left)
(map! :map 'override "C-S-l" #'+evil/window-move-right)
(map! :map 'override "C-S-k" #'+evil/window-move-up)
(map! :map 'override "C-S-j" #'+evil/window-move-down)
(map! :map 'override "C-h" #'evil-window-left)
(map! :map 'override "C-l" #'evil-window-right)
(map! :map 'override "C-k" #'evil-window-up)
(map! :map 'override "C-j" #'evil-window-down)
(map! :map 'org-mode-map "C-<right>" #'org-down-element)
(map! :map 'org-mode-map "C-<left>" #'org-up-element)
(map! :map 'org-mode-map "C-<down>" #'org-forward-element)
(map! :map 'org-mode-map "C-<up>" #'org-backward-element)
(map! :map 'override "C-S-r" #'evil-window-rotate-downwards)
(map! :map 'override "C-M-r" #'evil-window-rotate-upwards)
(map! :map 'override "|" nil)
(map! :m "|" #'split-window-right)
(map! :leader "w |" nil)
(map! :leader "w |" #'split-window-right)
(map! :m "C-w |" nil)
(map! :m "C-w |" #'split-window-right)
(map! :leader "w #" nil)
(map! :m "C-w #" nil)
(map! :map 'override "#" nil)
(map! :leader "w #" #'split-window-below)
(map! :m "C-w #" #'split-window-below)
(map! :m "#" #'split-window-below)
(map! :m "C-v" #'split-window-right)
;; (map! :g "C-e" nil)
;; (map! :i "C-e" nil)
;; (map! :map 'override "C-e" #'corfu-quit)
;; (map! :map 'corfu-mode-map "C-e" #'corfu-quit)
;; (map! :map 'corfu-mode-map "C-g" nil)
;; (map! :map 'corfu-mode-map "TAB" nil)
;; (map! :map 'corfu-mode-map "[tab]" nil)
;; (map! :map 'corfu-mode-map "S-TAB" nil)
;; (map! :map 'corfu-mode-map "[backtab]" nil)

;; (map! :map 'corfu-map "C-e" #'corfu-quit)
;; (map! :map 'corfu-map "C-g" nil)
;; (map! :map 'corfu-map "TAB" nil)
;; (map! :map 'corfu-map "[tab]" nil)
;; (map! :map 'corfu-map "S-TAB" nil)
;; (map! :map 'corfu-map "[backtab]" nil)

(use-package evil-nerd-commenter
  :bind ("C-/" . evilnc-comment-or-uncomment-lines))

(map! :n  "C-a"   #'evil-numbers/inc-at-pt
      :v  "C-a"   #'evil-numbers/inc-at-pt-incremental
      :v  "C-S-a" #'evil-numbers/inc-at-pt
      :n  "C-x"   #'evil-numbers/dec-at-pt
      :v  "C-x"   #'evil-numbers/dec-at-pt-incremental)
