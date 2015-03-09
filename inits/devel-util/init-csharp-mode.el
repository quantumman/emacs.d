(require 'csharp-mode)
(require 'omnisharp)


;; See http://stackoverflow.com/questions/1799191/how-can-i-fix-csharp-mode-el
(defvar csharp-mode-syntax-table-no-special-slash
  (let ((res (copy-syntax-table csharp-mode-syntax-table)))
    (modify-syntax-entry ?\\ "w" res)
    res)
  "same as regular csharp-mode-syntax-table, only \\ is not an escape char")

(defadvice c-guess-basic-syntax (after c-guess-basic-syntax-csharp-hack activate)
  "following an #if/#endif, indentation gets screwey, fix it"
  (let ((res ad-return-value))
    (save-excursion
      (save-match-data
        (cond ((and (eq major-mode 'csharp-mode)
                    (eq 'statement-cont (caar res))
                    (progn
                      (goto-char (cadar res))
                      (looking-at "#")))
               ;; when following a #if, try for a redo
               (goto-char (cadar res))
               (setq ad-return-value (c-guess-basic-syntax)))

              ((and (eq major-mode 'csharp-mode)
                    (eq 'string (caar res)))
               ;; inside a string
               ;; check to see if it is a literal
               ;; and if so, redo with modified syntax table
               (let ((p (point))
                     (extent (c-literal-limits)))
                 (when extent
                   (goto-char (- (car extent) 1))
                   (when (looking-at "@\"")
                     ;; yup, a string literal
                     (with-syntax-table csharp-mode-syntax-table-no-special-slash
                       (goto-char p)
                       (setq ad-return-value (c-guess-basic-syntax))))))))))))
(ad-activate 'c-guess-basic-syntax)
;;

(defun csharp-mode-hook-function ()
  (omnisharp-mode)
  (setq comment-column 40
        c-basic-offset 4
        indent-tabs-mode nil
        )
  ;; オフセットの調整
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 0)
  (c-set-offset 'cpp-macro-cont '+)
  (c-set-offset 'cpp-macro 0)
  (hl-line-mode 1)
  )
(add-hook 'csharp-mode-hook 'csharp-mode-hook-function)
(setq omnisharp-server-executable-path
      (expand-file-name "bin/Omnisharp/server/OmniSharp/bin/Debug/OmniSharp.exe"))

(define-key omnisharp-mode-map "." 'omnisharp-add-dot-and-auto-complete)

(require 'el-init)
(el-init-provide)
