(server-start)

(defun iconify-emacs-when-server-is-done ()
  (unless server-clients (iconify-frame)))

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
  (do-action-if-not-emacs-buffer
   (current-buffer)
   #' (lambda ()
        (save-buffer)
        (let ((from-buffer (current-buffer)))
          (switch-to-buffer (get-previous-buffer-or-scratch))
	  (kill-buffer from-buffer))))
  (flet ((yes-or-no-p (arg) "yes"))
    (server-edit)))

(defun get-previous-buffer-or-scratch ()
  "Return previous buffer if current buffer is not emacs buffer.
If the buffer is emacs buffer, then it returns scratch buffer."
  (if (string-match "\\*.+\\*" (buffer-name (other-buffer)))
      (get-buffer-create "*scratch*")
    (other-buffer)))

(add-hook 'server-visit-hook
	  '(lambda ()
	     (require 'init.encoding)
	     (init-emacs-encoding)
	     ))
(custom-set-variables '(server-kill-new-buffers t))

;; (add-hook 'server-switch-hook
;;           'switch-window-for-emacsclient)

(defun switch-window-for-emacsclient ()
  (require 'init.windows)
  (let ((window (get-window-id window-for-emacsclient)))
    ;; (win:save-window win:current-config)
    (if (aref win:configs window)
        (anything-switch-to-window window-for-emacsclient)
      (progn
        (anything-switch-to-window window-for-emacsclient)
        (delete-other-windows)
        )))
  (server-switch-buffer))

(defvar window-for-emacsclient "s"
  "The name of window on which emacsclient runs.")

;; (add-hook 'server-done-hook
;;           '(lambda ()
;;              (win:store-config win:current-config)
;;              (win-prev-window 1)
;;              ))

(defalias 'exit 'elscreen-save-and-killall)

(provide 'init.emacs-server)
