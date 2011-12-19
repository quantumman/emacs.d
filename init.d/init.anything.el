;;;; Initialization read in the first time for anything

;;;; anything.el
(require 'anything)
(require 'anything-startup)
(anything-complete-shell-history-setup-key (kbd "C-o"))
(global-set-key (kbd "M-y") 'anything-show-kill-ring)
;; (global-set-key (kbd "C-x C-o") 'anything-for-files)

(require 'ac-anything)
(define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-anything)

(require 'split-root)
(defun anything-display-function--split-root (buf)
  (let ((percent 40.0))
    (set-window-buffer (split-root-window
			(truncate (* (frame-height) (/ percent 100.0)))) buf)))
(setq anything-display-function 'anything-display-function--split-root)

;;;; helpers for programming
;; moving among functions
(defun alcs-describe-function (name)
  (describe-function (anything-c-symbolify name)))
(defun alcs-describe-variable (name)
  (describe-variable (anything-c-symbolify name)))

(defcustom anything-for-files-prefered-list-including-elscreen
  '(anything-c-source-ffap-line
    ;; anything-c-source-elscreen
    anything-c-source-ffap-guesser
    anything-c-source-buffers+
    anything-c-source-recentf
    anything-c-source-bookmarks
    anything-c-source-file-cache
    anything-c-source-files-in-current-dir+
    anything-c-source-locate)
  "Your prefered sources to find files."
  :type 'list
  :group 'anything-config)

(defun anything-for-files-and-tabs ()
  "This is anything-for-files including elscreen tabs."
  (interactive)
  (anything-other-buffer anything-for-files-prefered-list-including-elscreen
			 "anything for files including tabs")
  )
(global-set-key (kbd "C-x C-o") 'anything-for-files-and-tabs)

(provide 'init.anything)