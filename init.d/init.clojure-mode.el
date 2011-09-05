;;;; clojure mode
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins/swank-clojure/"))
(require 'slime)
(require 'clojure-mode)
(require 'swank-clojure)
(add-hook 'clojure-mode-hook
	  '(lambda ()
	     (setq inferior-lisp-program "clojure")))
(push (expand-file-name "~/.clojure/clojure-contrib/classes/") swank-clojure-classpath)
(push '("\\.clj$" . clojure-mode) auto-mode-alist)

(provide 'init.clojure-mode)