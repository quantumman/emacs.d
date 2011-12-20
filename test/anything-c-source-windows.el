(defvar anything-c-source-windows
      '((name . "Other windows")
        (candidates . anything-window-candinates)
        (action . (lambda (window)
                    (let* ((to-window (car (split-string window " ")))
                           (window-id (- (string-to-char to-window) ?`))
                           (action (cdr (anything-window-actions to-window))))
                      (win:save-window win:current-config)
                      (with-temp-buffer
                        (win-switch-to-window 1 window-id)
                        (when action (funcall action)))
                      )))))

(defun anything-window-candinates ()
  (loop for buffer-list in (get-buffer-lists)
        for window = (char-to-string (+ ?` (car buffer-list)))
        for buffers = (cdr buffer-list)
        collect (format "%s [%s]" (car (anything-window-actions window))
                        (mapconcat #'identity buffers " "))))

(defun anything-window-actions (w)
  (let ((action (cdr (assoc w anything-window-config))))
    (if action action (list w))))

(setq anything-window-config
  '(
    ("t" "twitter" #'twit)
    ("o" "org" #'(lambda () (unless (eq major-mode 'org-mode) (princ "open-org-mode")))))
  )

(require 'cl)
(defun get-buffer-lists ()
  (loop for i from 1 to (- win:max-configs 1)
        for buffers = (mapcar #'string-trim (split-string (aref win:names i) "/"))
        collect (cons i buffers)))

(defun string-trim (str)
  (replace-regexp-in-string "^\\s-+\\|\\s-+$" "" str))
