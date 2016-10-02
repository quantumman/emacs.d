(custom-set-variables
 '(eclim-eclipse-dirs '("/Application/eclipse")))

(require 'eclim)
(global-eclim-mode)
(require 'eclimd)

(ac-emacs-eclim-config)

(require 'el-init)
(el-init-provide)
