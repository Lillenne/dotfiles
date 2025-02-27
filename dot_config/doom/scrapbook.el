;;; scrapbook.el -*- lexical-binding: t; -*-
;;; Description: Utilities for scrapbooking in org. Insert photos and videos with autocomplete, thumbnail generation, and transcoding.
(require 's)
(require 'org)

(defvar my/org-insert-default-directory org-directory)

(defun my/org-insert-image (file &optional name caption width align)
  "Insert an image without creating a thumbnail."
  (interactive (list
                (read-file-name "Which image? " (or my/org-insert-default-directory default-directory) nil t)
                (read-string "Name: ")
                (read-string "Caption: " nil nil "")
                (read-number "Width: ")
                (completing-read "Align: " '("CENTER" "LEFT" "RIGHT"))))
  (when (f-exists? file)
    (require 's)
    (unless (s-blank? caption)
      (insert "#+CAPTION: " caption)
      (newline-and-indent))
    (insert "#+NAME: " (if (not (s-blank? name)) name (file-name-base file)))
    (newline-and-indent)
    (when (or (> 0 width) align)
      (insert
       "#+ATTR_HTML:"
       (unless (s-blank? align) (concat " :align " align))
       (unless (< width 1) (concat " :width " (number-to-string width) "px")))
      (newline-and-indent))
    (org-insert-link nil (s-concat "file:" file) nil)))

(defun my/append-width (str width &optional h)
  (let ((file (expand-file-name str))
        (s-width (if (stringp width) width (number-to-string width))))
    (my/make-relative (s-concat
                       (file-name-sans-extension file)
                       "-"
                       (if h
                           (s-concat "x" s-width ".")
                         (s-concat s-width "x."))
                       (file-name-extension file)))))

(defun my/make-relative (str)
  (let ((file (expand-file-name str)))
    (concat "./" (dired-make-relative file default-directory))))

(defun my/org-insert-image-thumbnail (file &optional name caption width align)
  "Insert an image and create a thumbnail with imagemagick."
  (interactive (list
                (read-file-name "Which image? " (or my/org-insert-default-directory default-directory) nil t nil #'my/image-predicate)
                (read-string "Name: ")
                (read-string "Caption: " nil nil "")
                (read-number "Width: ")
                (completing-read "Align: " '("CENTER" "LEFT" "RIGHT"))))
  (when (f-exists? file)
    (require 's)
    (let* ((s-width (number-to-string width))
           (thumbnail (my/append-width file s-width current-prefix-arg))
           (to-append (if current-prefix-arg (s-concat "x" s-width " ") (s-concat s-width "x ")))
           (command (s-concat "magick " file " -resize " to-append thumbnail)))
      (shell-command command)
      (unless (s-blank? caption)
        (insert (concat "#+CAPTION: " caption))
        (newline-and-indent))
      (unless (s-blank? name)
        (insert "#+NAME: "
                (if (not (s-blank? name)) name (file-name-base file))))
      (newline-and-indent)
      (unless (s-blank? align)
        (insert "#+ATTR_HTML: :align " align)
        (newline-and-indent))
      (org-insert-link nil (s-concat "file:" (my/make-relative file)) (s-concat "file:" thumbnail)))))

(defvar my/video-file-extensions '(".mov" ".mp4") "List of valid video file extensions.")
(defvar my/image-file-extensions '(".jpg" ".jpeg" ".tif" ".tiff" ".nef" ".heic" ".png" ".webp") "List of valid image file extensions.")
(defun my/video-predicate (file) (my/file-predicate file my/video-file-extensions))
(defun my/image-predicate (file) (my/file-predicate file my/image-file-extensions))
(defun my/file-predicate (file extensions)
  (or (f-directory? file) (--any (s-ends-with? it file t) extensions)))

(defun my/org-insert-video (file &optional name caption width align)
  "Insert a video with html5 export. Presumes HDR and converts to SDR mp4. Requires fancy export option.
Negative or 0 `WIDTH' means do not set html video tag width."
  (interactive (list
                (read-file-name "Which video? " (or my/org-insert-default-directory default-directory) nil t nil #'my/video-predicate)
                (read-string "Name: ")
                (read-string "Caption: " nil nil "")
                (read-number "Width: ")
                (completing-read "Align: " '("CENTER" "LEFT" "RIGHT"))))
  (when (f-exists? file)
    (require 's)
    (let ((s-width (number-to-string width))
          (relative (my/make-relative file))
          (compat (my/make-relative (s-concat (file-name-sans-extension (expand-file-name file)) "-rsz.mp4"))))
      ;; (message "dd: %s\ncompat: %s" default-directory compat) (sleep-for 20)
      (async-shell-command
       ;; TODO defaulting to conda ffmpeg, need system. full path for now
       (concat "/usr/bin/ffmpeg -i "
               file
               " -vf zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p "
               ;; "-c:v libx264 -crf 17 -preset veryslow -tune film -c:a copy "
               "-c:v h264_nvenc -qp 15 -profile:v high444p -pix_fmt yuv444p -tune hq -preset p7 -rc constqp -rc-lookahead 32 -c:a copy "
               compat))

      ;; #+ATTR_HTML: :controls controls :width 350
      ;; #+BEGIN_video
      ;; #+HTML: <source src="movie.mp4" type="video/mp4">
      ;; #+HTML: <source src="movie.ogg" type="video/ogg">
      ;; Your browser does not support the video tag.
      ;; #+END_video

      ;; (unless (s-blank? caption) (insert "#+CAPTION: " caption))
      ;; (newline-and-indent)
      (unless (s-blank? name)
        (insert "#+NAME: " name)
        (newline-and-indent))
      (insert "#+BEGIN_EXPORT html")
      (newline-and-indent)
      (insert "<div style=\"display: block; margin: 0 auto; width: " s-width "px;\">")
      (newline-and-indent)
      (insert "<video loop autoplay muted controls=\"controls\" " (unless (s-blank? align) (concat "align=\"" (downcase align) "\" ")) "width=\"" s-width "\">")
      (newline-and-indent)
      (insert "<source src=\"" compat "\" type=\"video/mp4\"/>")
      (newline-and-indent)
      (insert "<p>" relative "</p>")
      (newline-and-indent)
      (insert "</video>")
      (newline-and-indent)
      (insert "<p style=\"text-align: center\">" caption "</p>")
      (newline-and-indent)
      (insert "</div>")
      (newline-and-indent)
      (insert "#+END_EXPORT")
      (newline-and-indent)
      ;; (insert
      ;;  "#+ATTR_HTML:"
      ;;  ":controls controls"
      ;;  (unless (s-blank? align) (concat " :align " align))
      ;;  (unless (< width 1) (concat " :width " (number-to-string width) "px")))
      ;; (newline-and-indent)
      ;; (insert "#+BEGIN_video")
      ;; (newline-and-indent)
      ;; (insert "#+HTML: <source src=\"" file "\" type=\"video" "\">")
      ;; (newline-and-indent)
      ;; (insert "#+END_video")

      (org-insert-link nil relative nil))))

(map! (:map org-mode-map
       ;; :localleader :desc "Insert image" "l i" #'my/org-insert-image
       :localleader :desc "Insert image with thumbnail" "l m" #'my/org-insert-image-thumbnail
       :localleader :desc "Insert video" "l v" #'my/org-insert-video
       ))
