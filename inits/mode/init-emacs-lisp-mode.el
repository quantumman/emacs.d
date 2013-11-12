(defun emacs-lisp-mode-font-lock ()
  (set-face-foreground 'font-lock-builtin-face "VioletRed")
  (set-face-foreground 'font-lock-string-face  "LightSalmon4")
  (set-face-foreground 'font-lock-keyword-face "purple4")
  (set-face-foreground 'font-lock-constant-face "SkyBlue4")
  (set-face-foreground 'font-lock-function-name-face "NavyBlue")
  (set-face-foreground 'font-lock-variable-name-face "DarkGoldenrod4")
  (set-face-foreground 'font-lock-type-face "DarkGreen")
  ;;(set-face-foreground 'font-lock-warning-face "OrangeRed4")
  (set-face-bold-p 'font-lock-function-name-face nil)
  (set-face-bold-p 'font-lock-type-face nil)
  (set-face-bold-p 'font-lock-string-face nil)
  (set-face-bold-p 'font-lock-warning-face nil)
  )

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (emacs-lisp-mode-font-lock)
            ))

(require 'el-init)
(el-init:provide)