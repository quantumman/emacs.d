(require 'helm)
(require 'helm-command)
(require 'helm-config)
(require 'helm-misc)

;; misc

(setq helm-idle-delay             0.3
      helm-input-idle-delay       0.1
      helm-candidate-number-limit 200)

;; helm, source definitions

(defcustom helm-c-sources-buffers
  '(helm-c-source-elscreen
    helm-c-source-ffap-line
    helm-c-source-ffap-guesser
    helm-c-source-buffers-list
    helm-c-source-recentf
    helm-c-source-bookmarks
    helm-c-source-file-cache
    helm-c-source-files-in-current-dir
    helm-c-source-mac-spotlight)
  "List of buffers"
  :type 'list
  :group 'helm-config)

;; custom commands

(defun helm-find-other-buffers ()
  "This is helm-for-buffers."
  (interactive)
  (helm-other-buffer helm-c-sources-buffers
                     "open files or buffers by elscreen, bookmark and filename"))

;; key bindings

(let ((key-and-func
       `((,(kbd "C-x C-o") helm-find-other-buffers)
         (,(kbd "C-^")     helm-c-apropos)
         (,(kbd "C-;")     helm-resume)
         (,(kbd "M-x")     helm-M-x)
         (,(kbd "M-y")     helm-show-kill-ring)
         (,(kbd "M-z")     helm-do-grep)
         (,(kbd "C-S-h")   helm-descbinds)
        )))
  (loop for (key func) in key-and-func
        do (global-set-key key func)))

(require 'el-init)
(el-init:provide)
