;;; company.el -*- lexical-binding: t; -*-

(after! company
        (add-hook 'after-init-hook 'company-tng-mode)
        (setq company-minimum-prefix-length 1)
        (setq company-idle-delay 0)
        (require 'company-quickhelp)
        (map! :map 'company-mode-map "M-h"  #'company-quickhelp-manual-begin)
        (setq company-quickhelp-delay 0) ; nil = trigger only with alt-h.
        ;; (company-quickhelp-mode)
        (add-hook 'company-tng-mode-hook (lambda () (company-quickhelp-mode nil))) ; enable quickhelp only after tng
        ;; (company-quickhelp-mode) ;;sometimes doesn't work with tng
        )
