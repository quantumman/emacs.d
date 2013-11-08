(require 'auto-complete)
(require 'ajc-java-complete)
(require 'ajc-java-complete-config)

(add-hook 'java-mode-hook 'ajc-java-complete-mode)
(add-hook 'find-file-hook 'ajc-4-jsp-find-file-hook)

(require 'el-init)
(el-init:provide)
