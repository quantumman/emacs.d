(server-start)

(defun iconify-emacs-when-server-is-done ()
  (unless server-clients (iconify-frame)))

(defun elscreen-buffer-still-exist-p ()
  (let ((elscree-keeping-to-be-alive ()))
    (and (buffer-name (current-buffer)) (elscreen-get-screen-to-name-alist)
	 t)))

(defun elscreen-save-and-killall ()
  (interactive)
  (require 'elscreen-server)
  (server-edit)
  (do-action-if-not-emacs-buffer (current-buffer) #'save-buffer)
  (if (elscreen-buffer-still-exist-p)
      (elscreen-kill (elscreen-get-current-screen))
    (elscreen-kill-screen-and-buffers))
  (elscreen-kill (elscreen-get-current-screen))
  (message ""))

(defun win-save-and-killall ()
  (interactive)
  (server-edit)
  (do-action-if-not-emacs-buffer (current-buffer) #'save-buffer)
  (see-you-again)
  (message ""))

(defun do-action-if-not-emacs-buffer (buffer action)
  "Do action if a given buffer is emacs buffer."
  (when (not (string-match "\\*.+\\*" (buffer-name buffer)))
    (funcall action)))

(defun kill-buffer-with-save ()
  (interactive)
  (server-edit)
  (do-action-if-not-emacs-buffer
   (current-buffer)
   #' (lambda ()
	(save-buffer)
	(let ((from-buffer (current-buffer)))
	  (switch-to-buffer (get-previous-buffer-if-scratch))
	  (kill-buffer from-buffer)))))

(defun get-previous-buffer-or-scratch ()
  "Return previous buffer if current buffer is not emacs buffer.
If the buffer is emacs buffer, then it returns scratch buffer."
  (if (string-match "\\*.+\\*" (buffer-name (other-buffer)))
      (get-scratch-buffer)
    (other-buffer)))

(defun get-scratch-buffer ()
  (find-if #'(lambda (buffer) (string-equal "*scratch*" (buffer-name buffer)))
	   (buffer-list)))

(add-hook 'server-visit-hook
	  '(lambda ()
	     (require 'init.encoding)
	     (init-emacs-encoding)
	     ))
(custom-set-variables '(server-kill-new-buffers t))

(global-set-key (kbd "C-x C-c") 'kill-buffer-with-save)
(defalias 'exit 'win-save-and-killall)

(provide 'init.emacs-server)
