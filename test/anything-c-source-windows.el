(setq anything-c-source-windows
      '((name . "Other windoes")
        (candidates . (lambda ()
                        (loop for buffer-list in (get-buffer-lists)
                              for window = (char-to-string (+ ?` (car buffer-list)))
                              for buffers = (cdr buffer-list)
                              collect(format "%s [%%s]" window buffers)
                              )
                        )
        )
      )

(aref win:names-prefix 1)

(require 'cl)
(defun get-buffer-lists ()
  (loop for i from 1 to (- win:max-configs 1)
        for buffers = (mapcar #'string-trim (split-string (aref win:names i) "/"))
        do (win:store-config i)
        collect (cons i buffers)))

(defun string-trim (str)
  (replace-regexp-in-string "^\\s-+\\|\\s-+$" "" str))

(car (assoc 2 (get-buffer-lists)))
(string-trim "hoge ")

(aref win:names 1)
(win:store-config 1)
(aref win:configs 0)

(aref win:buflists 3)

(win:current-config)