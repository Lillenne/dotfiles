;;; jupyter.el -*- lexical-binding: t; -*-
(require 'pyvenv)
(pyvenv-activate "/home/aus/micromamba/envs/ml/")
;; (use-package elpy
;;   :ensure t
;;   :init
;;   (elpy-enable)
;;   :config
;;   (setq elpy-autodoc-delay 0.3)
;;   (require 'pyvenv)
;; (pyvenv-activate "/home/aus/micromamba/envs/ml/")
;;                                         ; notebook mode hook maybe?
;;   (setq elpy-rpc-virtualenv-path 'current)
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
