;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 編集行を目立たせる（現在行をハイライト表示する）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "dark slate gray"))
    (((class color)
      (background light))
     (:background "white smoke"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
;; (setq hl-line-face 'background)
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

    ;; フォントセットを作る
    (let* ((fontset-name "default") ; フォントセットの名前
    	   (size 13) ; ASCIIフォントのサイズ [9/10/12/14/15/17/19/20/...]
    	   (asciifont "Monaco") ; ASCIIフォント
    	   (jpfont "Hiragino Maru Gothic ProN") ; 日本語フォント
    	   (font (format "%s-%d:weight=normal:slant=normal" asciifont size))
    	   (fontspec (font-spec :family asciifont))
    	   (jp-fontspec (font-spec :family jpfont))
    	   (fsn (create-fontset-from-ascii-font font nil fontset-name)))
      (set-fontset-font fsn 'japanese-jisx0213.2004-1 jp-fontspec)
      (set-fontset-font fsn 'japanese-jisx0213-2 jp-fontspec)
      (set-fontset-font fsn 'katakana-jisx0201 jp-fontspec) ; 半角カナ
      (set-fontset-font fsn '(#x0080 . #x024F) fontspec) ; 分音符付きラテン
      (set-fontset-font fsn '(#x0370 . #x03FF) fontspec) ; ギリシャ文字
      )

    ;; デフォルトのフレームパラメータでフォントセットを指定
    (add-to-list 'default-frame-alist '(font . "fontset-default"))

    ;; フォントサイズの比を設定
    (dolist (elt '(("^-apple-hiragino.*" . 1.2)
    		   (".*osaka-bold.*" . 1.0)
    		   (".*osaka-medium.*" . 1.0)
    		   (".*courier-bold-.*-mac-roman" . 1.0)
    		   (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
    		   (".*monaco-bold-.*-mac-roman" . 0.9)))
      (add-to-list 'face-font-rescale-alist elt))

    ;; デフォルトフェイスにフォントセットを設定
    ;; # これは起動時に default-frame-alist に従ったフレームが
    ;; # 作成されない現象への対処
    (set-face-font 'default "fontset-default"))


  (when (or cygwin-p windows-p)
    ;; @ coding system
    ;; 日本語入力のための設定
    (set-keyboard-coding-system 'cp932)

    (prefer-coding-system 'utf-8-dos)
    (set-file-name-coding-system 'cp932)
    (setq default-process-coding-system '(cp932 . cp932))

    ;; cp932エンコード時の表示を「P」とする
    (coding-system-put 'cp932 :mnemonic ?P)
    (coding-system-put 'cp932-dos :mnemonic ?P)
    (coding-system-put 'cp932-unix :mnemonic ?P)
    (coding-system-put 'cp932-mac :mnemonic ?P)


    ;; 全角チルダ/波ダッシュをWindowsスタイルにする
    (let ((table (make-translation-table-from-alist '((#x301c . #xff5e))) ))
      (mapc
       (lambda (coding-system)
	 (coding-system-put coding-system :decode-translation-table table)
	 (coding-system-put coding-system :encode-translation-table table)
	 )
       '(utf-8 cp932 utf-16le)))


    ;; ------------------------------------------------------------------------
    ;; @ encode

    ;; 機種依存文字
    (when  (require 'cp5022x nil t)
      (define-coding-system-alias 'euc-jp 'cp51932)

      ;; decode-translation-table の設定
      (coding-system-put 'euc-jp :decode-translation-table
			 (get 'japanese-ucs-jis-to-cp932-map 'translation-table))
      (coding-system-put 'iso-2022-jp :decode-translation-table
			 (get 'japanese-ucs-jis-to-cp932-map 'translation-table))
      (coding-system-put 'utf-8 :decode-translation-table
			 (get 'japanese-ucs-jis-to-cp932-map 'translation-table))

      ;; encode-translation-table の設定
      (coding-system-put 'euc-jp :encode-translation-table
			 (get 'japanese-ucs-cp932-to-jis-map 'translation-table))
      (coding-system-put 'iso-2022-jp :encode-translation-table
			 (get 'japanese-ucs-cp932-to-jis-map 'translation-table))
      (coding-system-put 'cp932 :encode-translation-table
			 (get 'japanese-ucs-jis-to-cp932-map 'translation-table))
      (coding-system-put 'utf-8 :encode-translation-table
			 (get 'japanese-ucs-jis-to-cp932-map 'translation-table))

      ;; charset と coding-system の優先度設定
      (set-charset-priority 'ascii 'japanese-jisx0208 'latin-jisx0201
			    'katakana-jisx0201 'iso-8859-1 'cp1252 'unicode)
      (set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932))

    ;; fontの設定
    (set-face-attribute 'default nil
                    :family "Consolas"
                    :height 110)
    (set-fontset-font nil
                      'japanese-jisx0208
                      (font-spec :family "MS Gothic"))
    (set-fontset-font nil
                      'katakana-jisx0201
                      (font-spec :family "MS Gothic"))

    (setq face-font-rescale-alist
	  '((".*profont-medium.*" . 1.0)
		(".*profont-bold.*" . 1.0)
		(".*nfmotoyacedar-bold.*" . 1.4)
		(".*nfmotoyacedar-medium.*" . 1.4)
		("-cdac$" . 1.3)))
    )

  (global-whitespace-mode 1)

  ;; スペースの定義は全角スペースとする。
  (setq whitespace-space-regexp "\x3000+")

  ;; 改行の色を変更
  (set-face-foreground 'whitespace-newline "gray60")

  ;; スペースの色を変更
  (set-face-foreground 'whitespace-hspace "gray80")
  (set-face-background 'whitespace-hspace "gray80")
  (set-face-foreground 'whitespace-space "gray80")
  (set-face-background 'whitespace-space "gray80")


  ;; 半角スペースと改行を除外
  (dolist (d '((space-mark ?\ ) (newline-mark ?\n)))
    (setq whitespace-display-mappings
	  (delete-if
	   '(lambda (e) (and (eq (car d) (car e))
			     (eq (cadr d) (cadr e))))
	   whitespace-display-mappings)))

  ;; 全角スペースと改行を追加
  (dolist (e '((space-mark   ?\x3000 [?\□])
	       (newline-mark ?\n     [?\u21B5 ?\n] [?$ ?\n])))
    (add-to-list 'whitespace-display-mappings e))

  ;; 強調したくない要素を削除
  (dolist (d '(face lines space-before-tab
		    indentation empty space-after-tab tab-mark))
    (setq whitespace-style (delq d whitespace-style)))
)

(when (= emacs-major-version 22)
  (when carbon-p (require 'carbon-font)))

(provide 'init.appearance)
