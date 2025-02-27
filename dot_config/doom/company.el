;;; company.el -*- lexical-binding: t; -*-

;;(add-hook! some-mode (add-hook 'completion-at-point-functions #'some-capf depth t))
(use-package corfu
  ;; TAB-and-Go customizations
  :custom
  (corfu-cycle t)           ;; Enable cycling for `corfu-next/previous'
  (corfu-preselect 'prompt) ;; Always preselect the prompt
  ;; (corfu-preselect 'valid)
  (corfu-popupinfo-delay '(0.1 . 0.3))
  ;; (+corfu-want-ret-to-confirm both)

  ;; Use TAB for cycling, default is `corfu-complete'.
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))
  ;; ("TAB" . nil)
  ;; ([tab] . nil)
  ;; ("S-TAB" . nil)
  ;; ([backtab] . nil)
  ;; ("C-e" . corfu-quit))

  :init
  (global-corfu-mode))

;; (after! company
;;   ;; (add-hook 'after-init-hook 'company-tng-mode)
;;   (setq company-minimum-prefix-length 2)
;;   ;; (setq company-idle-delay 0)
;;   (require 'company-quickhelp)
;;   (map! :map 'company-mode-map "M-h"  #'company-quickhelp-manual-begin)
;;   (setq company-quickhelp-delay 0.2) ; nil = trigger only with alt-h.
;;   ;; (company-quickhelp-mode)
;;   (add-hook 'company-tng-mode-hook (lambda () (company-quickhelp-mode nil))) ; enable quickhelp only after tng
;;   ;; (company-quickhelp-mode) ;;sometimes doesn't work with tng
;;   )
