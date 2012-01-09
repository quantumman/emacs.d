;;;; Inuit.windows.el
(require 'revive)
;; Those configurations are the source of confusion.
;; windows.el has configuration of window as vector
;; and it is initialized when declared using defvar.
;; So those initialization use a given parameters
;; before user defined.
;; Any configs I set after (require 'windows)
;; do not work since the above reason.
;; Be careful to change configs.
(setq win:base-key ?`)
(setq win:max-configs 27)
(setq win:use-frame nil)
(setq win:quick-selection nil)
(setq win:switch-prefix "\C-z")
(setq revive:ignore-buffer-pattern "\\*.+\\*")
(require 'windows)
(define-key global-map win:switch-prefix nil)
(define-key win:switch-map ";" 'win-switch-menu)
(define-key win:switch-map "\C-z" 'win-toggle-window)
(define-key win:switch-map "=" 'anything-scroll-other-window)
(define-key global-map (kbd "\C-z\C-n") 'win-next-window)
(define-key global-map (kbd "\C-z\C-p") 'win-prev-window)
(loop for c from ?a to ?z
      do (define-key global-map
      	   (format "\C-z%s" (char-to-string c))
      	   'win-switch-to-window))
(win:startup-with-window)
(run-with-idle-timer 30 t 'win-save-all-configurations)

(defvar anything-c-source-windows
      '((name . "Windows")
        (candidates . anything-window-candinates)
        (action ("Switch to window" . anything-switch-to-window)
                ("Delete window" . anything-delete-window))
        ))

(defun anything-switch-to-window (window)
  "Switch to a given window."
  (let ((window-id (anything-get-selected-window-id window)))
    (win:save-window win:current-config)
    (win:switch-window window-id nil nil)))

(defun anything-delete-window (window)
  "Delete a given window."
  (let ((window-id (anything-get-selected-window-id window)))
    (win:save-window win:current-config)
    (win:delete-window window-id)))

(defun anything-get-selected-window-id (selected-window)
  "Get a window as representing number from a selected window in Anything menu.
\"selected-window\",  which is an argument supposed to be given by Anything,
is the following format: \"NAME [BUFFER1 \\ BUFFER2 \\ ...]\".
NAME means the name of window. The left parameters BUFFER* following NAME
is buffer names opened in the window.
This function parses the above format and returns \"NAME\"."
  (let ((window (car (split-string selected-window " "))))
    (get-window-id window)))

(defun anything-window-candinates ()
  "Return window candinates."
  (loop for window in (get-windows)
        for buffers = (get-buffers-of-a-window window)
        when (aref win:configs (get-window-id window))
        collect (format "%s [%s]" window buffers)))

(defadvice anything-other-buffer (before anything-other-buffer-before)
  ;; enforce to save current buffer names
  ;; because current buffer names are not set into
  ;; win:names which holds buffer names for each window immediately.
  (win:set-window-name win:current-config))
(ad-activate 'anything-other-buffer)

(defun get-windows ()
  "Return windows representing from \"a\" to \"z\"."
  (loop for i from 1 to (- win:max-configs 1)
        collect (char-to-string (+ ?` i))))

(defun get-buffers-of-a-window (window)
  "Get buffers of a given window as a string.
Each buffer in the string is separated by \"/\"."
  (let* ((window-id (get-window-id window))
         (window-buffers (aref win:names window-id)))
    (if (string-equal window-buffers "")
        nil
      window-buffers)))

(defun get-window-id (window)
  "Get window id (number) from a given window."
  (- (string-to-char window) ?`))

(defun get-current-window ()
  "Get current window."
  (char-to-string (+ ?` win:current-config)))

(provide 'init.windows)