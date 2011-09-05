;;;; Buffer Configs
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffer-re "*[^*]+*")

(iswitchb-mode 1)
(setq read-buffer-function 'iswitchb-read-buffer)
(setq iswitchb-regexp nil)
(setq iswitchb-prompt-newbuffer nil)

(setq recentf-max-saved-items 500)
(setq recentf-exclude '("/TAG$" "/var/tmp/"))
(require 'recentf-ext)

(setq bookmark-save-flags 1)
(progn
  (setq bookmark-sort-flag nil)
  (defun bookmark-arrange-latest-top ()
    (let ((latest (bookmark-get-bookmark bookmark)))
      (setq bookmark-alist (cons latest (delq latest bookmark-alist))))
    (bookmark-save))
  (add-hook 'bookmark-after-jump-hook 'bookmark-arrange-latest-top))

(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)

(require 'goto-chg)
(define-key global-map (kbd "<f8>") 'goto-last-change)
(define-key global-map (kbd "S-<f8>") 'goto-last-change-reverse)

;; (require 'tempbuf)
;; (add-hook 'find-file-hooks 'turn-on-tempbuf-mode)
;; (add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)

(provide 'init.buffer-conf)