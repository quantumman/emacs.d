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

(defun region-set-key (key-binding c1 c2)
  "Set commands for a key bindings.
c1 is called when region is activated, and c2 is called when region is not activated."
  (unless (commandp c1)
    (error "Not command: %S" c1))
  (unless (commandp c2)
    (error "Not command: %S" c2))
  (lexical-let ((command1 c1)
                (command2 c2))
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
