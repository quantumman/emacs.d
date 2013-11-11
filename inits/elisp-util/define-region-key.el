(defmacro compose-region-command (region-command command)
    `(unless (commandp ,region-command)
       (error "Not command: %S" ,region-command))
    `(unless (commandp ,command)
      (error "Not command: %S" ,command))
    `(lexical-let ((command1 ,region-command)
                   (command2 ,command))
       (if (use-region-p)
           (progn
             (funcall command1 (region-beginning) (region-end))
             (deactivate-mark))
           (funcall command2)
       )))

(defun define-region-key (keymap key-binding region-command command)
  "Set multiple commands for a key bindings.
region-command is called when region is activated, and command is called when region is not activated."
  (lexical-let ((c1 region-command)
                (c2 command))
    (define-key keymap key-binding
                    (lambda ()
                      (interactive)
                      (compose-region-command c1 c2)
                      ))))

(require 'el-init)
(el-init:provide)
