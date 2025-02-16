;;; company.el -*- lexical-binding: t; -*-

(after! company
        (setq company-minimum-prefix-length 1)
        (setq company-idle-delay 0.1)
        (require 'company-quickhelp)
        (setq company-quickhelp-delay 0.75)
        (add-hook 'company-tng-mode-hook (lambda () (company-quickhelp-mode nil))) ; enable quickhelp only after tng
        ;; (company-quickhelp-mode) ;;sometimes doesn't work with tng
        )
