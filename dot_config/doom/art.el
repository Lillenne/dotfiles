(require 's)
(defvar my/figlet-font nil "Font to use for figlet.")
(defun my/ascii-art (text)
  (interactive "sInsert ascii art of: ")
  (unless (s-blank? text)
    (let ((start (point)))
      (insert (shell-command-to-string (concat "figlet " (when my/figlet-font (concat "-f " my/figlet-font " ")) text)))
      (when current-prefix-arg
        (evilnc-comment-operator start (point))))))
(map! "C-c i" #'my/ascii-art)

(defun my/ascii-art-to-clipboard (text)
  (interactive "sInsert ascii art of: ")
  (kill-new
   (shell-command-to-string (concat "figlet " (when my/figlet-font (concat "-f " my/figlet-font " ")) text))))

(defun my/ascii-art-set-font ()
  (interactive)
  (let* ((output (shell-command-to-string "showfigfonts"))
         (fonts (s-match-strings-all "^[[:alnum:]]+" output))
         (selected (completing-read "Font: " fonts nil t)))
    (setq my/figlet-font selected)))
;; slant, shadow, script, mini, digital, banner
;; c center
;; cklnoprstvxDELNRSWX
