;;; -*- coding: utf-8; lexical-binding: t -*-
(require 'tabbar)

(tabbar-mode t)
;; 左に表示されるボタンを無効化
(custom-set-variables
 '(tabbar-buffer-home-button '(("" . nil) . ("" . nil)))
 '(tabbar-scroll-left-button '(("" . nil) . ("" . nil)))
 '(tabbar-scroll-right-button '(("" . nil) . ("" . nil)))
 '(tabbar-cycle-scope 'tab)
 )
(setq tabbar-separator-value "｜")

;; 外観変更
(set-face-attribute
 'tabbar-default nil
 :family (face-attribute 'default :family)
 :background (face-attribute 'default :background)
 :height 0.9)
(set-face-attribute
 'tabbar-unselected nil
 :background (face-attribute 'mode-line-inactive :background)
 :foreground (face-attribute 'mode-line-inactive :foreground)
 :box nil)
(set-face-attribute
 'tabbar-selected nil
 :background (face-attribute 'default :background)
 :foreground (face-attribute 'default :foreground)
 :box nil)
(set-face-attribute
 'tabbar-separator nil
 :background (face-attribute 'default :background)
 :foreground (face-attribute 'mode-line-inactive :foreground)
 :height 1.2)

(defun my-tabbar-buffer-groups (&optional buffer) ;; customize to show all normal files in one group
   "Returns the name of the tab group names the current buffer belongs to.
 There are two groups: Emacs buffers (those whose name starts with '*', plus
 dired buffers), and the rest.  This works at least with Emacs v24.2 using
 tabbar.el v1.7."
   (let ((b (or buffer (current-buffer))))
     (list (cond ((string-equal "*" (substring (buffer-name b) 0 1)) "Emacs")
                 ((eq major-mode 'dired-mode) "Dired")
                 (t
                  ;; Return `mode-name' if not blank, `major-mode' otherwise.
                  (if (and (stringp mode-name)
                           ;; Take care of preserving the match-data because this
                           ;; function is called when updating the header line.
                           (save-match-data (string-match "[^ ]" mode-name)))
                      mode-name
                    (symbol-name major-mode)))
                 ))))
(setq tabbar-buffer-groups-function 'my-tabbar-buffer-groups)

(defun my-tabbar-buffer-list ()
  (delq nil
        (mapcar #'(lambda (b)
                    (cond
                     ;; Always include the current buffer.
                     ((eq (current-buffer) b) b)
                     ((buffer-file-name b) b)
                     ((char-equal ?\  (aref (buffer-name b) 0)) nil)
                     ((string= (buffer-name b) helm-find-file-buffer-name) nil)
                     ((buffer-live-p b) b)))
                (buffer-list))
        ))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)


(eval-after-load-1 "init-helm"
  (require 'dash)
  (require 'cl)

  (setq helm-sources-grouping-buffers-list
        `((name . "Grouping Buffers")
          (candidates-in-buffer)
          (init . (lambda ()
                    (helm-init-candidates-in-buffer
                     'global
                     (->>
                         (tabbar-buffer-list)
                       (--filter (string=
                                  (->> (my-tabbar-buffer-groups) (car))
                                  (->> (my-tabbar-buffer-groups it) (car))))
                       (-map 'buffer-name)
                       (--filter (not (string= it helm-find-file-buffer-name)))
                       ))))
          (type . buffer)
          (persistent-action . helm-buffers-list-persistent-action)
          (volatile)
          (no-delay-on-input)
          (mode-line . helm-buffer-mode-line-string)
          (persistent-help
           . "Show this buffer / C-u \\[helm-execute-persistent-action]: Kill this buffer")
          )
        )

  (unless (-contains? (default-value 'helm-c-sources-buffers) 'helm-sources-grouping-buffers-list)
    (setq new-helm-c-sources-buffer
          (push 'helm-sources-grouping-buffers-list (default-value 'helm-c-sources-buffers)))
    (custom-set-variables
     '(helm-c-sources-buffers new-helm-c-sources-buffer)
     ))
  )

(require' el-init)
(el-init:provide)
