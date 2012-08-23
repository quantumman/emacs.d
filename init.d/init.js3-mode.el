(defvar ac-source-javascript-reserved-words
  '((candidates  . (list "break" "case" "catch" "continue" "debugger" "default" "delete"
                         "do" "else" "finally" "for" "function" "if" "in" "instanceof"
                         "new" "return"  "switch"  "this" "throw" "throw" "try"
                         "typeof" "var" "void" "while" "with"))
    (cache)))

(add-hook 'js3-mode-hook
          '(lambda ()
             (setq ac-sources
                  '(ac-source-javascript-reserved-words
                    ac-source-yasnippet
                    ac-source-words-in-same-mode-buffers
                    ac-source-abbrev))
	     (setq js3-indent-tabs-mode t)
	     ))

(provide 'init.js3-mode)
