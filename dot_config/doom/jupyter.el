;;; jupyter.el -*- lexical-binding: t; -*-

;; (require 'pyvenv)
;; (setenv "WORKON_HOME" "~/micromamba/envs/")
;; (pyvenv-mode 1)
;; (setq lsp-pyright-venv-path (expand-file-name "~/micromamba/envs/"))

;; not really working with micromamba. doesn't have the mamba config --show --json command
;; (require 'conda)
;; (custom-set-variables
;;  '(conda-anaconda-home (expand-file-name "~/miniforge3/"))
;;  '(conda-env-home-directory (expand-file-name "~/miniforge3/")))
;; (custom-set-variables
;;  '(conda-anaconda-home (expand-file-name "~/micromamba") (expand-file-name "~/miniforge3/"))
;;  '(conda-env-home-directory (expand-file-name "~/miniforge3/")))
;; ;; '(conda-env-executables-dir "/usr/bin/"))
;; (setq conda-home-candidates (expand-file-name "~/miniforge3/")
;;       conda-env-subdirectory "envs")
;; (conda-mode-line-setup)
;; (require 'conda-projectile)
;; (conda-projectile-mode-line-setup)
;; ;; (conda-env-autoactivate-mode) ;; this is causing an issue! falls back to sysem env
;; (conda-env-initialize-interactive-shells)
;; (conda-env-autoactivate-mode t)
;; ;; ;; if you want to automatically activate a conda environment on the opening of a file:
;; (add-hook 'find-file-hook (lambda () (when (bound-and-true-p conda-project-env-path)
;;                                        (conda-env-activate-for-buffer))))
(use-package! conda
  :config
  (setq conda-anaconda-home (expand-file-name  "~/miniforge3"))
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell)
  ;; (conda-env-autoactivate-mode t)
  (add-hook 'find-file-hook (lambda () (when (bound-and-true-p conda-project-env-path)
                                         (conda-env-activate-for-buffer)))))

(use-package! ein
  :custom
  (ein:jupyter-server-use-subcommand "server"))

;; (pyvenv-activate "/home/aus/micromamba/envs/ml/")
;; (use-package elpy
;;   :ensure t
;;   :init
;;   (elpy-enable)
;;   :config
;;   (setq elpy-autodoc-delay 0.3)
;;   ;; (require 'pyvenv)
;;   ;; (pyvenv-activate "/home/aus/micromamba/envs/ml/")
;;                                         ; notebook mode hook maybe?
;;   (setq elpy-rpc-virtualenv-path 'current)
;;   (add-hook! elpy-mode (add-hook 'completion-at-point-functions #'elpy-yapf-fix-code depth t))
;;   ;; (add-hook! elpy-mode (add-hook 'completion-at-point-functions #'elpy-yapf-fix-code depth t))
;;   ;;(set-company-backend! 'elpy-mode 'elpy-company-backend)
;;   )

(defvar ak/jupyter-buffer-name "*jupyter*")
(defvar ak/jupyter-dir "~/jupyter")
(defvar ak/jupyter-cmd "mj"); alias for setting up jupyter server
(defvar ak/jupyter-post-cleanup-cmd "mda"); alias for setting up jupyter server
(defvar ak/jupyter-url-or-port "http://localhost:8888/lab"); alias for setting up jupyter server
(require 'vterm)
(defun ak/start-jupyter ()
  (interactive)
  (if (get-buffer ak/jupyter-buffer-name) (switch-to-buffer (get-buffer ak/jupyter-buffer-name)) ; todo regexp or similar to determine if started
    (progn
      (save-window-excursion
        (cd ak/jupyter-dir)
        (vterm ak/jupyter-buffer-name)
        (vterm-send-string ak/jupyter-cmd)
        (vterm-send-return)
        )
      (sleep-for 0.8)
      (ein:login ak/jupyter-url-or-port #'(lambda (buffer url-or-port) (switch-to-buffer buffer)))
      )))
(map! :leader "J s" #'ak/start-jupyter)
(defun ak/kill-jupyter ()
  (interactive)
  (when (get-buffer ak/jupyter-buffer-name)
    (save-window-excursion
      (ein:stop nil ak/jupyter-url-or-port)
      (switch-to-buffer (get-buffer ak/jupyter-buffer-name))
      (vterm-send-key "c" nil nil t)
      (vterm-send "y")
      (vterm-send-return)
      (vterm-send-string ak/jupyter-post-cleanup-cmd)
      (vterm-send-return)
      (vterm-send-string "exit")
      (vterm-send-return)
      (kill-matching-buffers ".*ein.*" nil t)
      )))
(map! :leader "J k" #'ak/kill-jupyter)
