(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(org-todoist ts s package-lint))
 '(safe-local-variable-values
   '((org-list-indent-offset . 2)
     (eval and buffer-file-name
      (not
       (eq major-mode 'package-recipe-mode))
      (or
       (require 'package-recipe-mode nil t)
       (let
           ((load-path
             (cons "../package-build" load-path)))
         (require 'package-recipe-mode nil t)))
      (package-recipe-mode)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
