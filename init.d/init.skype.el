;;;; load skype emacs interface
(when (require 'skype nil t)
  ((lambda ()
     (setq skype--my-user-handle "quantumman_")
     (skype--init))
   ))
(defun skype ()
  (interactive)
  (skype--open-all-users-buffer-command))

(provide 'init.skype)