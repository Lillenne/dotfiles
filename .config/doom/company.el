;;; company.el -*- lexical-binding: t; -*-

(company-quickhelp-mode)

(with-eval-after-load 'company
  (define-key company-active-map (kbd "<tab>") #'company-complete)
  (define-key company-active-map (kbd "C-<right>") #'company-indent-or-complete-common)
  (define-key company-active-map (kbd "<backtab>") #'company-quickhelp-manual-begin)
  )
;; (eval-after-load 'company
;;   '(define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind
  (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (add-hook ein:notebook-mode-hook (lambda () (setq company-backends '((elpy-company-backend :separate company-capf company-yasnippet)))))
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))
