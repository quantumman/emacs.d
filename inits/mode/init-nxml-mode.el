(require 'nxml-mode)

(add-hook 'nxml-mode-hook
          '(lambda ()
             (auto-complete-mode)
             (setq indent-tabs-mode nil
                   nxml-child-indent 2
                   nxml-attribute-indent 2
                   )))

(require 'auto-complete-nxml)


(require 'el-init)
(el-init:provide)
