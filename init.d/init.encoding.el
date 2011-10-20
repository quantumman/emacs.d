(require 'env-test)

(defun init-emacs-encoding ()
  (set-language-environment 'utf-8)
  (if (or cocoa-p darwin-p)
      (progn
	(require 'ucs-normalize)
	(prefer-coding-system 'utf-8-hfs)
	(setq file-name-coding-system 'utf-8-hfs)
	(setq locale-coding-system 'utf-8-hfs)
	(set-terminal-coding-system 'utf-8-hfs)
	(set-keyboard-coding-system 'utf-8-hfs)
	)
    (progn
      (prefer-coding-system 'utf-8)
      (setq file-name-coding-system 'utf-8)
      (setq locale-coding-system 'utf-8)
      (set-terminal-coding-system 'utf-8)
      (set-keyboard-coding-system 'utf-8)
      )))

(init-emacs-encoding)
(provide 'init.encoding)