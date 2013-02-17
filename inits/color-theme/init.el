(require 'color-theme)
(require 'color-theme-tango)
(require 'color-theme-buffer-local)

(color-theme-initialize)

(add-hook 'eshell-mode-hook
          (lambda nil (color-theme-buffer-local 'color-theme-tango (current-buffer))))

(require 'el-init)
(el-init:provide)