;;; company.el -*- lexical-binding: t; -*-

(company-quickhelp-mode)
;;(setq company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend))
;;(setq company-selection-wrap-around t)
(setq company-minimum-prefix-length 0)
(setq company-idle-delay 0.05)
;;(setq company-require-match nil)
;;(setq company-require-match t)

;; (with-eval-after-load 'company
;;   (define-key company-active-map (kbd "RET") nil)
;;   (define-key company-active-map (kbd "<return>") nil)
;;   (define-key company-active-map (kbd "TAB") #'company-complete-selection)
;;   (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
;;   (define-key company-active-map (kbd "<backtab>") #'company-quickhelp-manual-begin)
;;   )
(eval-after-load 'company
  '(define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind
  ;; (:map company-active-map
  ;;        ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))
