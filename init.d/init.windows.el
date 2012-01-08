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
  (let ((window-id (anything-get-selected-window-id window)))
    (win:save-window win:current-config)
    (win-switch-to-window 1 window-id)))

(defun anything-delete-window (window)
  (let ((window-id (anything-get-selected-window-id window)))
    (win:save-window win:current-config)
    (win:delete-window window-id)))

(defun anything-get-selected-window-id (selected-window)
  (let ((window (car (split-string selected-window " "))))
    (get-window-id window)))

(defun anything-window-candinates ()
  (loop for window in (get-windows)
        for buffers = (get-buffers-of-a-window window)
        when (aref win:configs (get-window-id window))
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

(defun get-current-window ()
  (char-to-string (+ ?` win:current-config)))

(defun string-trim (str)
  (replace-regexp-in-string "^\\s-+\\|\\s-+$" "" Ste))

;;; save after immediately switching other buffer
(defadvice win:switch-window (after win:switch-window-after)
  (win:save-window win:current-config))HOGEEGEGE
(ad-activate 'win:switch-window)HOGEEGEGEHOGEEGEGE

(provide 'init.windows)