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

(defun spell-checking-or-kill-region ()
  "Run spell-checking if there is no marker,
run kill-region if marker and current point are different position."
  (interactive)
  (let ((start (mark-marker))
	(end (point-marker)))
    (if (region-active-p)
	(progn
	  (kill-region start end)
	  (deactivate-mark))
	(ispell-word)
	)))
(global-set-key "\C-w" 'spell-checking-or-kill-region)

(global-set-key "\C-f" 'forward-word)
(global-set-key "\C-b" 'backward-word)

(provide 'init.custom-key-binding)