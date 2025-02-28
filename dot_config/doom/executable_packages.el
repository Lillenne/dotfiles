;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
                                        ;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
                                        ;(package! another-package
                                        ;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
                                        ;(package! this-package
                                        ;  :recipe (:host github :repo "username/repo"
                                        ;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
                                        ;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
                                        ;(package! builtin-package :recipe (:nonrecursive t))
                                        ;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
                                        ;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
                                        ;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
                                        ;(unpin! pinned-package)
;; ...or multiple packages
                                        ;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
                                        ;(unpin! t)


;; (package! ob-mermaid)
(package! evil-owl)
(package! evil-quickscope)
(package! olivetti)
;;(package! evil-textobj-anyblock :disable t)
;;(package! evil-textobj-tree-sitter)
;; (package! ellama :recipe (:host github :repo "s-kostyaev/ellama"
;;                           :files ("ellama.el"))) ; requires ollama and a model, default zephyr
;; (package! org-hyperscheduler :recipe (:host github :repo "dmitrym0/org-hyperscheduler"))
(package! org-timeblock :recipe (:host github :repo "ichernyshovvv/org-timeblock"))
(package! evil-ReplaceWithRegister
  :recipe (:host github :repo "Dewdrops/evil-ReplaceWithRegister"
           :files ("evil-replace-with-register.el")))

;; (when (package! lsp-bridge
;;         :recipe (:host github
;;                  :repo "manateelazycat/lsp-bridge"
;;                  :branch "master"
;;                  :files ("*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
;;                  ;; do not perform byte compilation or native compilation for lsp-bridge
;;                  :build (:not compile)))
;;   (package! markdown-mode)
;;   (package! yasnippet))

;; (package! elpy)
(package! docstr)

(package! org-roam-ui)
(package! org-roam-timestamps)

;; (package! khoj :recipe (:host github :repo "khoj-ai/khoj" :files (:defaults "src/interface/emacs/khoj.el")))
(package! org-super-agenda)
(package! org-todoist
  :recipe (
           ;; :local-repo "/home/aus/projects/org-todoist/"
           :host github
           :repo "lillenne/org-todoist"
           :branch "main"
           :files ("org-todoist.el")))

(package! dotnet-new
  :recipe (
           :host github
           :repo "lillenne/dotnet-new"
           ;; :local-repo "/home/aus/projects/dotnet-new/"
           :branch "main"
           :files ("dotnet-new.el")))

;; (package! conda)

;; transient package issue: https://github.com/doomemacs/doomemacs/issues/8194
;; (package! transient :pin "00fabc76")
;; (package! magit :pin "7adad8c8")

(package! org-auto-tangle
  :recipe (:host github
           :repo "yilkalargaw/org-auto-tangle"
           :branch "master"
           :files ("org-auto-tangle.el")))

(package! chezmoi
  :recipe (:host github
           :repo "Lillenne/chezmoi.el"
           :branch "main"
           :files (:defaults "*.el" "extensions/*.el")))
