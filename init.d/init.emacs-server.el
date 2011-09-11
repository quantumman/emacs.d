(server-start)
(defun iconify-emacs-when-server-is-done ()
  (unless server-clients (iconify-frame)))
(defun elscreen-save-and-killall ()
  (interactive)
  (server-edit)
  (elscreen-kill-screen-and-buffers (elscreen-get-current-screen))
  (message ""))

(add-hook 'server-visit-hook
	  '(lambda ()
	     (elscreen-find-file buffer-file-truename)
	     (set-terminal-coding-system 'utf-8)
	     (set-keyboard-coding-system 'utf-8)
	     ))
(global-set-key (kbd "C-x C-c") 'elscreen-save-and-killall)
(defalias 'exit 'save-buffers-kill-emacs)

(provide 'init.emacs-server)