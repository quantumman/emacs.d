(require 'helm)
(require 'helm-command)
(require 'helm-config)
(require 'helm-misc)

;; misc

(setq helm-idle-delay             0.1
      helm-input-idle-delay       0.1
      helm-candidate-number-limit 100)

;; (require 'split-root)
;; (defun helm-display-function--split-root (buf)
;;   (let ((percent 40.0))
;;     (set-window-buffer (split-root-window
;;                        (truncate (* (frame-height) (/ percent 100.0)))) buf)))
;; (setq helm-display-function 'helm-display-function--split-root)

;; helm, source definitions

(defcustom helm-c-sources-buffers
  '(helm-c-source-elscreen
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
(defvar helm-find-file-buffer-name
  "open files or buffers by elscreen, bookmark and filename")

(add-to-list 'helm-source-elscreen
             '(candidate-transformer . remove-helm-buffer-name))
(defun remove-helm-buffer-name (cands)
  (loop for c in cands
        for helm-buffer-name = (concat ":" helm-find-file-buffer-name)
        collect (replace-regexp-in-string helm-buffer-name "" c)
   ))

(defun helm-find-files-and-buffers ()
  "This is helm-for-buffers."
  (interactive)
  (helm-other-buffer helm-c-sources-buffers
                     helm-find-file-buffer-name))

;; key bindings

(let ((key-and-func
       `((,(kbd "C-x C-o") helm-find-files-and-buffers)
         (,(kbd "C-^")     helm-c-apropos)
         (,(kbd "C-;")     helm-resume)
         (,(kbd "M-x")     helm-M-x)
         (,(kbd "M-y")     helm-show-kill-ring)
         (,(kbd "M-z")     helm-do-grep)
         (,(kbd "C-S-h")   helm-descbinds)
        )))
  (loop for (key func) in key-and-func
        do (global-set-key key func)))

(require 'helm-git)
(define-key java-mode-map (kbd "M-f") 'helm-git-find-files)
(define-key nxml-mode-map (kbd "M-f") 'helm-git-find-files)


(require 'el-init)
(el-init:provide)
