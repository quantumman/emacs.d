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
(setq helm-c-sources-buffers
  '(helm-source-elscreen
    helm-source-buffers-list
    helm-source-recentf
    helm-source-bookmarks
    helm-source-file-cache
    helm-source-files-in-current-dir
    helm-source-mac-spotlight
    ))

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
  (unless helm-source-buffers-list
    (setq helm-source-buffers-list
          (helm-make-source "Buffers" 'helm-source-buffers)))
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

(add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))
(add-to-list 'helm-completing-read-handlers-alist '(iswitchb-buffer . nil))

(require 'helm-ls-git)
(define-key java-mode-map (kbd "M-f") 'helm-git-find-files)
(define-key nxml-mode-map (kbd "M-f") 'helm-git-find-files)

;;; quick-buffer-switch
(require 'quick-buffer-switch)
(setq qbs-prefix-key "C-x C-c") ;プレフィクスキー、C-x C-cは潰していいよね
(qbs-init)
(helm-mode 1)                      ;helmなどを入れないと使いづらい
(qbs-add-predicates                ;カスタマイズするときに囲む必要ある
 ;; M-x qbs-ruby-modeを定義
 (make-qbs:predicate
    :name 'ruby-mode   ;名前
    :shortcut "r"      ;C-x C-c rに割り当て
    ;; enh-ruby-modeかruby-modeかつファイルバッファ
    :test '(and (memq major-mode '(enh-ruby-mode ruby-mode))
                qbs:buffer-file-name)))

(require 'el-init)
(el-init:provide)
