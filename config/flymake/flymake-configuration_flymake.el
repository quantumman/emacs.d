(require 'flymake)

(defun flymake-get-make-cmdline (source base-dir)
  (list "make"
        (list "-s"
	      "-C"
              base-dir
              (concat "CHK_SOURCES=" source)
              "SYNTAX_CHECK_MODE=1"
	      "check-syntax"
	      )))

;; flymake latex 用の設定
(defun flymake-get-tex-args (file-name)
  (list "platex" (list "-file-line-error" "-interaction=nonstopmode" file-name)))

;; Save files and run makefile
(add-hook
 'c-mode-hook
 '(lambda ()
    (define-key c-mode-map "\C-cd" 'flymake-display-err-menu-for-current-line)))

(add-hook
 'c++-mode-hook
 '(lambda ()
    (define-key c++-mode-map "\C-cd" 'flymake-display-err-menu-for-current-line)))

(add-hook
 'yatex-mode-hook
 '(lambda()
    (define-key 'yatex-mode-map "\C-cd", 'flymake-complie)))

;; Display error in popup menu
(load-file (expand-file-name "~/.emacs.d/auto-install/popup.el"))
(defun credmp/flymake-display-err-popup ()
  "Displays the error/warning for the current line in the popup window"
  (interactive)
  (let* ((line-no             (flymake-current-line-no))
         (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count               (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
          ;;(message "[%s] %s" line text)
	  (popup-tip (format "[%s] %s" line text))
	  ))
      (setq count (1- count)))))


(defadvice flymake-mode (before post-command-stuff activate compile)
  "Automatically display the error message using popup on the line
that failed to flymake "
  (set (make-local-variable 'post-command-hook)
       (add-hook 'post-command-hook 'credmp/flymake-display-err-popup)))


(define-key global-map (kbd "C-c d") 'credmp/flymake-display-err-popup)


;; faces of flymake
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(face-font-family-alternatives (quote (("courier" "fixed") ("helv" "helvetica" "arial" "fixed") ("terminus")))))

;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(flymake-warnline
;;    ((((class color))
;;      (:foreground "blue" :underline "DarkOrange3" :background "blue"))))
;;  '(flymake-errline ((((class color))
;;  		     (:foreground "red" :underline "red" :background "pink"))))
;; ) 

(set-face-background 'flymake-warnline "sky blue")
(set-face-foreground 'flymake-warnline "DarkOrange3")
(set-face-underline 'flymake-warnline "DarkOrange3")

(set-face-background 'flymake-errline "pink")
(set-face-foreground 'flymake-errline "red")
(set-face-underline 'flymake-errline "red")


;; generate Makefile 
(defun flymake-init (compiler &rest flags)
    (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
	   (local-dir   (file-name-directory buffer-file-name))
	   (local-file  (file-relative-name
			 temp-file
			 local-dir)))
      (list compiler
	      (if (eq nil flags)
		  (list local-file local-dir)
		(if (listp (car flags))
		    (append (car flags) (list local-file local-dir))
		  (append flags (list local-file local-dir)))))))
	   

;; c mode 	      
(defun flymake-c-init ()
  (flymake-init "gcc" "-Wall" "-Wextra" "-fsyntax-only"))

(add-hook 'c-mode-hook
	  '(lambda ()
	     (push '(".+\\.c$" flymake-c-init) flymake-allowed-file-name-masks)
	     (push '(".+\\.h$" flymake-c-init) flymake-allowed-file-name-masks)
	     (if (not (null buffer-file-name)) (flymake-mode))))


;; c++ mode
(defun flymake-cc-init ()
    (flymake-init "g++" "-Wall" "-Wextra" "-fsyntax-only"))

(add-hook 'c++-mode-hook
          '(lambda ()
	     (push '(".+\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
	     (push '(".+\\.hpp$" flymake-cc-init) flymake-allowed-file-name-masks)
             (if (not (null buffer-file-name)) (flymake-mode))))


;; (defun flymake-haskell-init()
;;   (flymake-init "gcc" "-Wall"))


;; (push '(".+\\.hs$" flymake-haskell-init flymake-simple-java-cleanup)
;;       flymake-allowed-file-name-masks)
;; (push '(".+\\.lhs$" flymake-haskell-init flymake-simple-java-cleanup)
;;       flymake-allowed-file-name-masks)
;; (push '("^\\(\.+\.hs\\|\.lhs\\):\\([0-9]+\\):\\([0-9]+\\):\\(.+\\)"
;;  	1 2 3 4) flymake-err-line-patterns)

;; (add-hook 'haskell-mode-hook
;; 	  '(lambda ()
;; 	     (if (not (null buffer-file-name)) (flymake-mode))))
						
;; objective-c mode (xcode)
(defvar xcode:gccver "4.2.1")
(defvar xcode:sdkver "4.0")
(defvar xcode:sdkpath "/Developer/Platforms/iPhoneSimulator.platform/Developer")
(defvar xcode:sdk (concat xcode:sdkpath "/SDKs/iPhoneSimulator" xcode:sdkver ".sdk"))
(defvar flymake-objc-compiler "/Developer/usr/bin/gcc")
;; (defvar flymake-objc-compile-default-options (list "-Wall" "-Wextra" "-fsyntax-only" "-ObjC" "-std=c99" "-isysroot" xcode:sdk))
(defvar flymake-last-position nil)
(defvar flymake-objc-compile-default-options
  (list "-Wall" "-Wextra" "-fsyntax-only" "-fobjc-exceptions" "-fobjc-call-cxx-cdtors" "-std=c99" "-ObjC++"))
(defvar flymake-objc-compile-options
  (list "-I/opt/local/include" "-I." "-isysroot" xcode:sdk)) 


(defun flymake-objc-init ()       
  ;; (flymake-init "gcc" "-Wall" "-Wextra" "-fsyntax-only" "-ObjC++" "-std=c99"
  ;; "-I." "-I/opt/local/include" ))
  (flymake-init
   flymake-objc-compiler
   (append
    flymake-objc-compile-default-options 
    flymake-objc-compile-options)))

(add-hook 'objc-mode-hook
	  '(lambda ()
	     (push '("\\.m$" flymake-simple-make-init)
		   flymake-allowed-file-name-masks)
	     (push '("\\.mm$" flymake-simple-make-init)
		   flymake-allowed-file-name-masks)
	     (push '("\\.h$" flymake-simple-make-init)
		   flymake-allowed-file-name-masks)
	     (push '("\\.m$" flymake-objc-init) flymake-allowed-file-name-masks)
	     (push '("\\.mm$" flymake-objc-init) flymake-allowed-file-name-masks)
	     (push '("\\.h$" flymake-objc-init) flymake-allowed-file-name-masks)
	     (if (and (not (null buffer-file-name))
		      (file-writable-p buffer-file-name))
		 (flymake-mode t))
	     ))
(defun xcode:buildandrun ()
  (interactive)
  (do-applescript
   (format
    (concat
     "tell application \"Xcode\" to activate \r"
     "tell application \"System Events\" \r"
     "     tell process \"Xcode\" \r"
     "          key code 36 using {command down} \r"
     "    end tell \r"
     "end tell \r"
     ))))

(provide 'flymake-configuration)










