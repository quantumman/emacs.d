
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 編集行を目立たせる（現在行をハイライト表示する）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "dark slate gray"))
    (((class color)
      (background light))
     (:background "ForestGreen"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(setq hl-line-face 'underline) ; 下線
(global-hl-line-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; emacs appearnce
(when (not (or darwin-p ns-p carbon-p))
    (menu-bar-mode 0))
(tool-bar-mode 0)
;; disable the top page
(setq inhibit-startup-message t)
;; turn off beep
(setq ring-bell-function '(lambda ()))
;; font lock color
(add-hook 'font-lock-mode-hook
	  '(lambda ()
	     (set-face-foreground 'font-lock-builtin-face "VioletRed")
	     ;;(set-face-foreground 'font-lock-comment-face "t")
	     (set-face-foreground 'font-lock-string-face  "LightSalmon4")
	     (set-face-foreground 'font-lock-keyword-face "purple4")
	     (set-face-foreground 'font-lock-constant-face "SkyBlue4")
	     (set-face-foreground 'font-lock-function-name-face "NavyBlue")
	     (set-face-foreground 'font-lock-variable-name-face "DarkGoldenrod4")
	     (set-face-foreground 'font-lock-type-face "DarkGreen")
	     ;;(set-face-foreground 'font-lock-warning-face "OrangeRed4")
	     (set-face-bold-p 'font-lock-function-name-face nil)
	     (set-face-bold-p 'font-lock-type-face nil)
	     (set-face-bold-p 'font-lock-string-face nil)
	     (set-face-bold-p 'font-lock-warning-face nil)
	     ))


;; (set-cursor-color "Black")
;; (set-background-color "White")
;; (set-foreground-color "Black")
;; (set-frame-font "Monaco-12")

(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
      (progn
	;; use 120 char wide window for largeish displays
	;; and smaller 80 column windows for smaller displays
	;; pick whatever numbers make sense for you
	(if (> (x-display-pixel-width) 1280)
	    (add-to-list 'default-frame-alist (cons 'width 120))
	  (add-to-list 'default-frame-alist (cons 'width 80)))
	;; for the height, subtract a couple hundred pixels
	;; from the screen height (for panels, menubars and
	;; whatnot), then divide by the height of a char to
	;; get the height we want
	(add-to-list 'default-frame-alist
		     (cons 'height (/ (- (x-display-pixel-height) 200)
				      (frame-char-height)))))))

(set-frame-size-according-to-resolution)

(when (>= emacs-major-version 23)

  (when cocoa-p

    (setq fixed-width-use-QuickDraw-for-ascii t)
    (setq mac-allow-anti-aliasing t)
    (add-to-list 'default-frame-alist '(font . "fontset-default"))
    (set-face-attribute 'default nil
			:family "monaco"
			:height 130)

    (create-fontset-from-fontset-spec
     "-alias-fixed-medium-r-normal-*-16-*-*-*-c-*-fontset-16,
  japanese-jisx0208:-alias-fixed-medium-r-normal-*-16-*-JISX0208.1983-0,
  katakana-jisx0201:-alias-fixed-medium-r-normal-*-16-*-JISX0201.1976-0,
  japanese-jisx0213-1:-alias-fixed-medium-r-normal-*-16-*-JISX0213.2000-1,
  japanese-jisx0213-2:-alias-fixed-medium-r-normal-*-16-*-JISX0213.2000-2")

    (set-fontset-font
     ;; (frame-parameter nil 'font)
     "fontset-16"
     'japanese-jisx0208
     '("Hiragino Maru Gothic Pro" . "iso10646-1"))

    (set-fontset-font
     ;;(frame-parameter nil 'font)
     "fontset-16"
     'japanese-jisx0212
     '("Hiragino Maru Gothic Pro" . "iso10646-1"))

 ;;; Unicode フォント
 ;; (set-fontset-font
 ;;  (frame-parameter nil 'font)
 ;;  'mule-unicode-0100-24ff
 ;;  '("monaco" . "iso10646-1"))

;;; キリル，ギリシア文字設定
;;; 注意： この設定だけでは古代ギリシア文字、コプト文字は表示できない
;;; http://socrates.berkeley.edu/~pinax/greekkeys/NAUdownload.html が必要
;;; キリル文字
    (set-fontset-font
     (frame-parameter nil 'font)
     'cyrillic-iso8859-5
     '("monaco" . "iso10646-1"))

;;; ギリシア文字
    (set-fontset-font
     (frame-parameter nil 'font)
     'greek-iso8859-7
     '("monaco" . "iso10646-1"))

    (set-fontset-font
     (frame-parameter nil 'font)
     'katakana-jisx0201
     '("Hiragino Maru Gothic Pro" . "iso10646-1"))

    (setq face-font-rescale-alist
	  '(("^-apple-hiragino.*" . 1.2)
	    (".*osaka-bold.*" . 1.2)
	    (".*osaka-medium.*" . 1.2)
	    (".*courier-bold-.*-mac-roman" . 1.0)
	    (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
	    (".*monaco-bold-.*-mac-roman" . 0.9)
	    ("-cdac$" . 1.3)))
    ))

(when (= emacs-major-version 22)
  (when carbon-p (require 'carbon-font)
    ))


(provide 'init.appearance)
