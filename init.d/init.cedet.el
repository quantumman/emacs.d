;;;; CEDET
(load "cedet")
(require 'jde)
(require 'ecb)
(require 'semantic-ia)
(global-ede-mode 1)

(semantic-load-enable-code-helpers)
;;(semantic-idle-completions-mode 1)

(setq user-full-name "SYOUDAI, Yokoyama")
(setq user-mail-address "quantumcars@gmail.com")

;;;; JDEE
(setq jde-global-classpath '("/usr/share/java/j3dcore.jar"
			    "/usr/share/java/j3dutils.jar"
			    "/usr/share/java/vecmath.jar"
			    "."))
(setq jde-compiler "/usr/bin/javac")

(global-ede-mode 1)
(semantic-mode 1)
(define-key c++-mode-map "." 'semantic-complete-self-insert)
(define-key c++-mode-map ">" 'semantic-complete-self-insert)
(define-key c-mode-map "." 'semantic-complete-self-insert)
(define-key c-mode-map ">" 'semantic-complete-self-insert)
(setq semantic-load-turn-useful-things-on t)
(setq semantic-default-submodes
      '(
	global-semantic-idle-scheduler-mode
	global-semantic-idle-completions-mode
	global-semanticdb-minor-mode
	global-semantic-decoration-mode
	global-semantic-highlight-func-mode
	global-semantic-stickyfunc-mode
	global-semantic-mru-bookmark-mode
	))
(semantic-add-system-include "/usr/include/boost/" 'c++mode)
(semantic-add-system-include "/usr/include/" 'c++mode)

(provide 'init.cedet.el)