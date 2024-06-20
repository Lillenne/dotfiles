;;; company.el -*- lexical-binding: t; -*-

(after! company
        ;(add-hook 'after-init-hook 'company-tng-mode)
        (setq company-minimum-prefix-length 1)
        (setq company-idle-delay 0) ;0.1)
        (require 'company-quickhelp)
        (setq company-quickhelp-delay nil) ; nil = trigger only with alt-h. 0.75 good alternative
        (add-hook 'company-tng-mode-hook (lambda () (company-quickhelp-mode nil))) ; enable quickhelp only after tng
        ;; (company-quickhelp-mode) ;;sometimes doesn't work with tng
        )
