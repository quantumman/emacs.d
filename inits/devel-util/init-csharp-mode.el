(require 'csharp-mode)
(require 'omnisharp)

(defun csharp-mode-hook-function ()
  (omnisharp-mode)
  )
(add-hook 'csharp-mode-hook 'csharp-mode-hook-function)

(require 'el-init)
(el-init:provide)
