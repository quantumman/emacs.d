;; (require 'elscreen-server)
(server-start)

(defun iconify-emacs-when-server-is-done ()
  (unless server-clients (iconify-frame)))

;; (defun elscreen-buffer-still-exist-p ()
;;   (let ((elscree-keeping-to-be-alive ()))
;;     (and ((buffer-name) (elscreen-get-screen-to-name-alist))
;; 	 t)))

(defun elscreen-save-and-killall ()
  (interactive)
  (server-edit)
  ;; (save-buffer)
  ;; (if (elscreen-buffer-still-exist-p)
  ;;     (elscreen-kill (elscreen-get-current-screen))
  ;;   (elscreen-kill-screen-and-buffers))
  ;; (elscreen-kill (elscreen-get-current-screen))
  (message ""))

(defun kill-buffer-with-save ()
  (interactive)
  (server-edit)
  (when (not (string-match "\\*.+\\*" (buffer-name (current-buffer))))
    (save-buffer)
    (let ((from-buffer (current-buffer)))
      (switch-to-buffer (other-buffer))
      (kill-buffer from-buffer)
      )))

(add-hook 'server-visit-hook
	  '(lambda ()
	     (require 'init.encoding)
	     (init-emacs-encoding)
	     ))
(custom-set-variables '(server-kill-new-buffers t))

(global-set-key (kbd "C-x C-c") 'kill-buffer-with-save)
(defalias 'exit 'save-buffers-kill-emacs)

(provide 'init.emacs-server)
