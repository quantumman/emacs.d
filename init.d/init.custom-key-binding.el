;;;; Key bindings
;; Define the move point to top line of window
(defun point-to-top ()
  "Put point to top line of window."
  (interactive)
  (move-to-window-line 0))
(global-set-key "\C-t" 'point-to-top) ;; C-t = pointer moves to top of window

;; Define the move point to bottom line of window
(defun point-to-bottom ()
  "Put point to bottom line of window."
  (interactive)
  (move-to-window-line -1))
(global-set-key "\C-b" 'point-to-bottom) ;; C-b = pointer moves to bottom of window

(defun region-set-key (key-binding region-command command)
  "Set commands for a key bindings.
region-command is called when region is activated, and command is called when region is not activated."
  (unless (commandp region-command)
    (error "Not command: %S" region-command))
  (unless (commandp region-command)
    (error "Not command: %S" command))
  (lexical-let ((command1 region-command)
                (command2 command))
    (global-set-key key-binding
                    #'(lambda ()
                        (interactive)
                        (let ((start (mark-marker))
                              (end (point-marker)))
                          (if (region-active-p)
                              (progn
                                (funcall command1 start end)
                                (deactivate-mark))
                            (funcall command2)))))))

(region-set-key "\C-w" 'kill-region 'ispell-word)
(region-set-key [C-tab] 'indent-region 'indent-for-tab-command)

(global-set-key "\C-f" 'forward-word)
(global-set-key "\C-b" 'backward-word)

(provide 'init.custom-key-binding)
