(require 'env-test)

(defun init-emacs-encoding ()
  (set-language-environment 'utf-8)
  (cond  ((or cocoa-p darwin-p)
	     (require 'ucs-normalize)
	     (prefer-coding-system 'utf-8-hfs)
	     (setq file-name-coding-system 'utf-8-hfs)
	     (setq locale-coding-system 'utf-8-hfs)
	     (set-terminal-coding-system 'utf-8-hfs)
	     (set-keyboard-coding-system 'utf-8-hfs))
	 ((or windows-p cygwin-p nt-p)
	  (init-windows-emacs-encoding))
	 (t
	  (prefer-coding-system 'utf-8)
	  (setq file-name-coding-system 'utf-8)
	  (setq locale-coding-system 'utf-8)
	  (set-terminal-coding-system 'utf-8)
	  (set-keyboard-coding-system 'utf-8)
	  )))


(defun init-windows-emacs-encoding ()
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
  (require 'cp5022x)
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
  (set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932)
  )


(init-emacs-encoding)
(provide 'init.encoding)