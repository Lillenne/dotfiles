;;; quick-jump.el -*- lexical-binding: t; -*-


;; quick shortcuts
(defmacro ak/goto (suffix key)
  "Generates goto function for primary org files"
  (let ((methodname (concat "ak/goto-" suffix))
        (varname (concat "+org-capture-" suffix "-file"))
        (keybind (concat "j " key)))
    (eval `(defconst ,(intern varname) (expand-file-name (concat ,suffix ".org") org-directory)))
    (eval `(defun ,(intern methodname) () (interactive) (find-file (eval (intern ,varname)))))
    (eval `(map! :leader ,keybind #',(intern methodname)))
    nil))
(ak/goto "devenv" "c")
(ak/goto "notes" "n")
(ak/goto "projects" "p")
(ak/goto "gifts" "g")
(ak/goto "journal" "j")
(ak/goto "learn" "l")
(ak/goto "stories" "w")
(ak/goto "todoist" "q")
(ak/goto "todo" "t")
(ak/goto "reading-list" "r")
(ak/goto "memories" "M")
(ak/goto "meetings" "m")

;; (defvar +org-capture-meetings-file (ak/from-org-dir "meetings"))
;; (defvar +org-capture-memories-file (ak/from-org-dir "memories"))

;; (defun ak/find-calendar ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "calendar")))

;; (defun ak/find-calendar-family ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "calendar_family")))

;; (defun ak/find-calendar-work ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "calendar_work")))

;; (defun ak/find-memories ()
;;   (interactive)
;;   (find-file +org-capture-memories-file))

;; (defun ak/find-meetings ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "meetings")))

;; (defun ak/find-all-posts ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "all-posts")))

;; (defun ak/find-gifts ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "gifts")))

;; (defun ak/find-learn ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "learn")))

;; (defun ak/find-todo ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "todo")))

;; (defun ak/find-devenv ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "devenv")))

;; (defun ak/find-work ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "work")))

;; (defun ak/find-todoist ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "todoist")))

;; (defun ak/find-projects ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "projects")))

;; (defun ak/find-reading-list ()
;;   (interactive)
;;   (find-file (ak/from-org-dir "reading-list")))

;; (map! :leader (:prefix ("j" . "Quick files")
;;                        "s" #'ak/to-sprint
;;                        "m" #'ak/find-memories
;;                        "M" #'ak/find-meetings
;;                        "b" #'ak/find-all-posts
;;                        "g" #'ak/find-gifts
;;                        "l" #'ak/find-learn
;;                        "t" #'ak/find-todo
;;                        "d" #'ak/find-devenv
;;                        "w" #'ak/find-work
;;                        "q" #'ak/find-todoist
;;                        "p" #'ak/find-projects
;;                        "r" #'ak/find-reading-list
;;                        (:prefix ("jc" . "Calendar")
;;                                 "c" #'ak/find-calendar
;;                                 "w" #'ak/find-calendar-work
;;                                 "f" #'ak/find-calendar-family)))
