;;; todoist.el -*- lexical-binding: t; -*-

(map! :leader "T q" #'todoist-quick-new-task)
(map! :leader "T t" #'todoist)
(map! :leader "T T" #'todoist-task-menu)
