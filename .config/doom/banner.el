;;; banner.el -*- lexical-binding: t; -*-

;; (global-hide-mode-line-mode)
                                        ;(setq fancy-splash-image "")
;; (setq-default mode-line-format nil)
;; (setq-default evil-mode-line-format nil)
(setq +doom-dashboard-functions '(doom-dashboard-widget-banner))
;; (remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
;; (setq +doom-dashboard-menu-sections nil)
(defun my/banner ()
  (let* ((banner '(
                   ".____     .___ .__   .__                                   "
                   "|    |    |   ||  |  |  |    ____    ____    ____    ____  "
                   "|    |    |   ||  |  |  |  _/ __ \\  /    \\  /    \\ _/ __ \\ "
                   "|    |___ |   ||  |__|  |__\\  ___/ |   |  \\|   |  \\  ___/ "
                   "|_______ ||___||____/|____/ \\___  >|___|  /|___|  / \\___  >"
                   "        \\/                      \\/      \\/      \\/      \\/"
                   ))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat line (make-string (max 0 (- longest-line (length line))) 32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(setq +doom-dashboard-ascii-banner-fn #'my/banner)
