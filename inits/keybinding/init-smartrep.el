(require 'smartrep)
(require 'prefix-key)

(eval-after-load "smartrep"
  '(progn
     (smartrep-define-key global-map "M-g"
       '(("n" . 'next-error)
         ("p" . 'previous-error)
         ("C-n" . 'next-error)
         ("C-p" . 'previous-error)
         ))
     (smartrep-define-key global-map "C-q"
       '(("n" . (lambda () (scroll-other-window 1)))
         ("p" . (lambda () (scroll-other-window -1)))
         ("N" . 'scroll-other-window)
         ("P" . (lambda () (scroll-other-window '-)))
         ("a" . (lambda () (beginning-of-buffer-other-window 0)))
         ("e" . (lambda () (end-of-buffer-other-window 0)))))
     (eval-after-load "expand-region"
       '(progn
          (smartrep-define-key global-map "C-c"
            '(("=" . 'er/expand-region)
              ("-" . 'er/contract-region)
              ))))
     ))

(require 'el-init)
(el-init:provide)
