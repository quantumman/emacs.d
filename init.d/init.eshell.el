(require 'eshell)
(require 'env-test)

(setenv "PATH" "/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/home/Quantumman/.cabal/bin")
(if (or carbon-p cocoa-p)
    (setenv "EDITOR" "open -a emacs")
  (setenv "EDITOR" "emacsclient")
  )
(setenv "LC_ALL" "C")
(setenv "LANG" "ja_JP.UTF8")


(defun pcomplete/sudo ()
  "complete a command after sudo command."
  (interactive)
  (let ((pcomplete-help "complete after sudo"))
    (pcomplete-here (pcomplete-here (eshell-complete-commands-list )))))

(require 'ansi-color)
(provide 'init.eshell)