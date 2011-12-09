;; (require 'fsharp)

(setq auto-mode-alist (cons '("\\.fs[iylx]?$" . fsharp-mode) auto-mode-alist))
(autoload 'fsharp-mode "fsharp" "Major mode for editing F# code." t)
(autoload 'run-fsharp "inf-fsharp" "Run an inferior F# process." t)

(require 'env-test)
(when (or carbon-p darwin-p cocoa-p)
  (setq inferior-fsharp-program "/usr/bin/fsi")
  (setq fsharp-compiler "/usr/bin/fsc"))

(provide 'init.fsharp-mode)