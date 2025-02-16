;;; company.el -*- lexical-binding: t; -*-

(company-quickhelp-mode)

(with-eval-after-load 'company
  (define-key company-active-map (kbd "<tab>") #'company-complete)
  (define-key company-active-map (kbd "<C-right>") #'company-indent-or-complete-common)
  (define-key company-active-map (kbd "<backtab>") #'company-quickhelp-manual-begin)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.0))
