(defun fullscreen-toggle ()
  "Toggle fullscreen"
  (interactive)
  (if (eq (frame-parameter nil 'fullscreen) 'fullboth)
      (set-frame-parameter nil 'fullscreen nil)
    (set-frame-parameter nil 'fullscreen 'fullboth)
    ))

(require 'el-init)
(el-init-provide)
