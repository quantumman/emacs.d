(require 'helm)
(require 'helm-command)
(require 'helm-config)

;; misc

(setq helm-idle-delay             0.3
      helm-input-idle-delay       0.1
      helm-candidate-number-limit 200)

;; key bindings

(let ((key-and-func
       `((,(kbd "C-x C-o") helm-for-files)
         (,(kbd "C-^")     helm-c-apropos)
         (,(kbd "C-;")     helm-resume)
         (,(kbd "C-s")     helm-occur)
         (,(kbd "M-x")     helm-M-x)
         (,(kbd "M-y")     helm-show-kill-ring)
         (,(kbd "M-z")     helm-do-grep)
         (,(kbd "C-S-h")   helm-descbinds)
        )))
  (loop for (key func) in key-and-func
        do (global-set-key key func)))

(require 'el-init)
(el-init:provide)
