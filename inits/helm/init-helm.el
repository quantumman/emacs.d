(require 'helm)
(require 'helm-command)
(require 'helm-config)
(require 'helm-misc)
(require 'helm-swoop)

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


;; key bindings

(custom-set-variables
 '(helm-for-files-preferred-list '(helm-source-buffers-list
                                   helm-source-recentf
                                   helm-source-bookmarks
                                   helm-source-file-cache
                                   helm-source-files-in-current-dir
                                   helm-source-mac-spotlight
                                   ))
 )

(let ((key-and-func
       `((,(kbd "C-x C-o") helm-for-files)
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
(add-to-list 'helm-completing-read-handlers-alist '(find-file-at-point . nil))
(add-to-list 'helm-completing-read-handlers-alist '(iswitchb-buffer . nil))
(add-to-list 'helm-completing-read-handlers-alist '(iswitchb-kill-buffer . nil))
(add-to-list 'helm-completing-read-handlers-alist '(kill-buffer . nil))

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

;;; helm-swoop

(require 'helm-migemo)
(eval-after-load "helm-migemo"
  '(defun helm-compile-source--candidates-in-buffer (source)
     (helm-aif (assoc 'candidates-in-buffer source)
         (append source
                 `((candidates
                    . ,(or (cdr it)
                           (lambda ()
                             ;; Do not use `source' because other plugins
                             ;; (such as helm-migemo) may change it
                             (helm-candidates-in-buffer (helm-get-current-source)))))
                   (volatile) (match identity)))
       source)))


(require 'helm-swoop)
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
(setq helm-swoop-move-to-line-cycle nil)

(cl-defun helm-swoop-nomigemo (&key $query ($multiline current-prefix-arg))
  "シンボル検索用Migemo無効版helm-swoop"
  (interactive)
  (let ((helm-swoop-pre-input-function
         (lambda () (format "\\_<%s\\_> " (thing-at-point 'symbol)))))
    (helm-swoop :$source (delete '(migemo) (copy-sequence (helm-c-source-swoop)))
                :$query $query :$multiline $multiline)))
(global-set-key (kbd "C-M-:") 'helm-swoop-nomigemo)

;;; [2014-11-25 Tue]
(when (featurep 'helm-anything)
  (defadvice helm-resume (around helm-swoop-resume activate)
    "helm-anything-resumeで復元できないのでその場合に限定して無効化"
    ad-do-it))

;;; ace-isearch
(global-ace-isearch-mode 1)


(require 'el-init)
(el-init-provide)
