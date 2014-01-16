(defconst *dmacro-key* "\C-t" "繰返し指定キー")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)

(defmacro eval-after-load-1 (file &rest args)
  (declare (indent 1))
 `(eval-after-load ,file
    (quote (progn ,@args))))

(require 'el-init)
(el-init:provide)
