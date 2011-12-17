(require 'tabbar)
(require 'cl)

(tabbar-mode t)

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


(defun my-tabbar-buffer-list ()
  (remove-if
   (lambda (buffer)
     (or
      (string-match ".*\\*.+\\*" (buffer-name buffer))
      (when tabbar-exclude-list
	(any (funcall tabbar-exclude-list buffer)))))
   (buffer-list)))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)

(defvar tabbar-exclude-list 'tabbar-exclude-list-function
  "Returns function(s) to exclude buffers that you do not want to display as tab."
  )
(setq tabbar-exclude-list 'tabbar-exclude-list-function)

(defun tabbar-exclude-list-function (buffer)
  "Returns function(s) to exclude buffers that you do not want to display as tab."
  (list
   (string-equal (buffer-name buffer) "anything for files including tabs")))


;; utils
(defun any (lst &optional pred)
  (lexical-let ((pred (if (null pred) #'identity pred)))
    (loop for x in lst
	  for p = (funcall pred x)
	  if p return p
	  )))

(defun all (lst &optional pred)
  (lexical-let ((pred (if (null pred) #'identity pred)))
    (not (any lst pred))))

(provide 'init.tabbar)