;; from http://d.hatena.ne.jp/znz/20070519/flyspell
(mapc
 (lambda (hook)
   (add-hook hook 'flyspell-prog-mode))
 '(
   c-mode-common-hook
   emacs-lisp-mode-hook
   ))

(mapc
   (lambda (hook)
     (add-hook hook
	       '(lambda () (flyspell-mode 1))))
   '(
     changelog-mode-hook
     debian-control-mode-hook
     ruby-mode-hook
     text-mode-hook
     wl-draft-mode-hook
     tex-mode-hook
     ))

(provide 'flyspell-check)