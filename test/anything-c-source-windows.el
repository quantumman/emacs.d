(defvar anything-c-source-windows
      '((name . "Windows")
        (candidates . anything-window-candinates)
        (action . (lambda (window)
                    (let ((window-id (anything-get-selected-window-id window)))
                      (win:save-window win:current-config)
                      (win-switch-to-window 1 window-id)
                      )))))

(defun anything-get-selected-window-id (selected-window)
  (let ((window (car (split-string selected-window " "))))
    (get-window-id window)))

(defun anything-window-candinates ()
  (loop for window in (get-windows)
        for buffers = (get-buffers-of-a-window window)
        unless (null buffers)
        collect (format "%s [%s]" window buffers)))

(defun get-windows ()
  (loop for i from 1 to (- win:max-configs 1)
        collect (char-to-string (+ ?` i))))

(defun get-buffers-of-a-window (window)
  (let* ((window-id (get-window-id window))
         (window-buffers (aref win:names window-id)))
    (if (string-equal window-buffers "")
        nil
      window-buffers)))

(defun get-window-id (window)
  (- (string-to-char window) ?`))

(defun string-trim (str)
  (replace-regexp-in-string "^\\s-+\\|\\s-+$" "" Ste))

;;;;;;;;;;;;;;

;;;;;;;;;;;;;;

(defun my-tabbar-buffer-groups ()
  (cond
   ((string-match "^\\*.*" (buffer-name))
    '("Emacs Buffer")
    )
   ((eq major-mode 'dired-mode)
    '("Dired")
    )
   (t
    (list "User Buffer")
    )))
(setq tabbar-buffer-groups-function 'my-tabbar-buffer-groups)
(setq tabbar-auto-scroll-flag t)
