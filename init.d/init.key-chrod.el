;;;; key chrod
;;; allocate key bindings to 2 keys pushing at the same time.
(require 'key-chord)
(key-chord-mode t)
(setq key-chord-two-keys-delay 0.04)
(key-chord-define-global "jk" 'view-mode)
(key-chord-define emacs-lisp-mode-map "df" 'describe-function)


;; run xcode builder
(add-hook 'objc-mode-hook
	  #'(lambda ()  (key-chord-define objc-mode-map "xb" 'xcode:buildandrun)))


(provide 'init.key-chrod)



