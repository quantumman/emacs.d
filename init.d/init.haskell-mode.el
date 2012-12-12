;;; if you wont to be on those hook, then never use those hooks explicitly
;;; otherwise ghc-mod will turn off those hooks implicitly.
(add-hook 'haskell-mode-hook
          (lambda ()
            (turn-on-haskell-indent)
            (turn-on-haskell-doc-mode)
            ))
(setq haskell-font-lock-symbols nil)
(require 'inf-haskell)
(setq haskell-program-name "ghci -XTemplateHaskell")


(defun unicode-symbol (name)
  "Translate a symbolic name for a Unicode character -- e.g., LEFT-ARROW
 or GREATER-THAN into an actual Unicode character code. "
  (decode-char 'ucs (case name
                      (left-arrow 8592)
                      (up-arrow 8593)
                      (right-arrow 8594)
                      (down-arrow 8595)
                      (double-vertical-bar #X2551)
                      (equal #X003d)
                      (not-equal #X2260)
                      (identical #X2261)
                      (not-identical #X2262)
                      (less-than #X003c)
                      (greater-than #X003e)
                      (less-than-or-equal-to #X2264)
                      (greater-than-or-equal-to #X2265)
                      (logical-and #X2227)
                      (logical-or #X2228)
                      (logical-neg #X00AC)
                      ('nil #X2205)
                      (horizontal-ellipsis #X2026)
                      (double-exclamation #X203C)
                      (prime #X2032)
                      (double-prime #X2033)
                      (for-all #X2200)
                      (there-exists #X2203)
                      (element-of #X2208)
                      (square-root #X221A)
                      (squared #X00B2)
                      (cubed #X00B3)
                      (lambda #X03BB)
                      (alpha #X03B1)
                      (beta #X03B2)
                      (gamma #X03B3)
                      (delta #X03B4))))


(defun substitute-pattern-with-unicode (pattern symbol)
  "Add a font lock hook to replace the matched part of PATTERN with the
     Unicode symbol SYMBOL looked up with UNICODE-SYMBOL."
  (font-lock-add-keywords
   nil `((,pattern
          (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                    ,(unicode-symbol symbol)
                                    'decompose-region)
                    nil))))))


(defun substitute-patterns-with-unicode (patterns)
  "Call SUBSTITUTE-PATTERN-WITH-UNICODE repeatedly."
  (mapcar #'(lambda (x)
              (substitute-pattern-with-unicode (car x)
                                               (cdr x)))
          patterns))


(defun haskell-unicode ()
  (substitute-patterns-with-unicode
   (list (cons "\\(<-\\)" 'left-arrow)
         (cons "\\(->\\)" 'right-arrow)
         (cons "\\(==\\)" 'identical)
         (cons "\\(/=\\)" 'not-identical)
         (cons "\\(()\\)" 'nil)
         (cons "\\<\\(sqrt\\)\\>" 'square-root)
         (cons "\\(&&\\)" 'logical-and)
         (cons "\\(||\\)" 'logical-or)
         (cons "\\<\\(not\\)\\>" 'logical-neg)
         (cons "\\(>\\)\\[^=\\]" 'greater-than)
         (cons "\\(<\\)\\[^=\\]" 'less-than)
         (cons "\\(>=\\)" 'greater-than-or-equal-to)
         (cons "\\(<=\\)" 'less-than-or-equal-to)
         (cons "\\<\\(alpha\\)\\>" 'alpha)
         (cons "\\<\\(beta\\)\\>" 'beta)
         (cons "\\<\\(gamma\\)\\>" 'gamma)
         (cons "\\<\\(delta\\)\\>" 'delta)
         (cons "\\(''\\)" 'double-prime)
         (cons "\\('\\)" 'prime)
         (cons "\\(!!\\)" 'double-exclamation)
         (cons "\\(\\.\\.\\)" 'horizontal-ellipsis))))



(define-key haskell-mode-map [return] 'haskell-smart-newline)
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))


(defun haskell-smart-newline ()
  (interactive)
  (let ((action (haskell:smart-newline)))
    (funcall action)))

(defun haskell:smart-newline ()
  (save-excursion
    (beginning-of-line)
    (cond ((or (string= "import" (current-word))
               (string= "data" (current-word))
               (string= "type" (current-word))
               (string= "newtype" (current-word)))
           #'(lambda ()
               (delete-horizontal-space)
               (newline)))
          ((string-match "^[^\s+let].+\s*=\s*.*"
                         (buffer-substring-no-properties (point-at-bol) (point-at-eol)))
           #'(lambda ()
               (delete-horizontal-space)
               (newline-and-indent)))
          (())
          (t
           #'newline-and-indent
           ))))

(provide 'init.haskell-mode)
