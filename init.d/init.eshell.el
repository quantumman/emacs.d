(require 'eshell)
(require 'env-test)


(custom-set-variables
 '(eshell-ask-to-save-history (quote always))
 '(eshell-history-size 1000)
 '(eshell-ls-dired-initial-args (quote ("-h")))
 '(eshell-ls-exclude-regexp "~\\'")
 '(eshell-ls-initial-args "-h")
 '(eshell-ls-use-in-dired t nil (em-ls))
 '(eshell-modules-list (quote (eshell-alias eshell-basic
                                           eshell-cmpl eshell-dirs eshell-glob
                                           eshell-hist eshell-ls eshell-pred
                                           eshell-prompt eshell-rebind
                                           eshell-script eshell-smart
                                           eshell-term eshell-unix eshell-xtra)))
 '(eshell-prefer-to-shell t nil (eshell))
 '(eshell-stringify-t nil)
 '(eshell-term-name "ansi")
 '(eshell-visual-commands (quote ("vi" "top" "screen" "less" "lynx"
				  "ssh" "rlogin" "telnet" "diff")))
 )

;; (setenv "PATH" "/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/home/Quantumman/.cabal/bin")
;; (if (or carbon-p cocoa-p)
;;     (setenv "EDITOR" "open -a emacs")
;;   (setenv "EDITOR" "emacsclient")
;;   )
;; (setenv "LC_ALL" "C")
;; (setenv "LANG" "ja_JP.UTF8")

(defun pcomplete/sudo ()
  "complete a command after sudo command."
  (interactive)
  (let ((pcomplete-help "complete after sudo"))
    (pcomplete-here (pcomplete-here (eshell-complete-commands-list )))))

(defun eshell:string-shorten (source-string upper-length)
  (when (stringp source-string)
    (if (< upper-length (length source-string))
	(concat (substring source-string 0 (- upper-length 3)) "...")
      source-string
      )))

(defun eshell:replace-prefix-match-string (source-string from-string to-string)
  (when (and (stringp source-string)
	     (stringp from-string)
	     (stringp to-string))
    (when (string-match from-string source-string)
      (replace-match to-string nil nil source-string))))

(defun eshell:relative-file-path ()
  (let ((absolute-path (eshell/pwd))
	(home (getenv "HOME")))
    (if (string= absolute-path home)
	"~/"
      (eshell:replace-prefix-match-string absolute-path home "~")
	)))

(defun custom:eshell-prompt-function ()
  (let ((hostname (eshell:string-shorten (system-name) 5))
	(absolute-current-path (eshell/pwd)))
    (concat (getenv "USER") "@" hostname ":" (eshell:relative-file-path) "$ ")
    ))

(setq eshell-prompt-function #'custom:eshell-prompt-function)
(setq eshell-prompt-regexp "^[^#$\n]*[#$] ")

(require 'ansi-color)
(provide 'init.eshell)