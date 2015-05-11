(custom-set-variables
 '(eclim-eclipse-dirs '("/Application/eclipse")))

(require 'eclim)
(global-eclim-mode)
(require 'eclimd)

(require 'ac-emacs-eclim-source)
(ac-emacs-eclim-config)

(require 'el-init)
(el-init-provide)
