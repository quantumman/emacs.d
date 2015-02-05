;;; if you wont to be on those hook, then never use those hooks explicitly
;;; otherwise ghc-mod will turn off those hooks implicitly.
(add-hook 'haskell-mode-hook
          (lambda ()
            (turn-on-haskell-doc-mode)
            ))
(setq haskell-font-lock-symbols nil)
(require 'inf-haskell)
(setq haskell-program-name "ghci -XTemplateHaskell -i../ -iTest/ -itest/ -package ghc")


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



; (define-key haskell-mode-map [return] 'haskell-smart-newline)
(define-key haskell-mode-map [return] 'newline)
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


;; Sample file for the new session/process stuff
;; Based on my own configuration. Well, it IS my configuration.
;;
;; NOTE: If you don't have cabal-dev, or you don't want to use it, you
;; should change haskell-process-type (see below) to 'ghci.
;;
;; To merely TRY this mode (and for debugging), do the below:
;;
;;     cd into haskell-mode's directory, and run
;;     $ emacs --load examples/init.el
;;
;; To get started, open a .hs file in one of your projects, and hit…
;;
;;   1. F5 to load the current file (and start a repl session), or
;;   2. C-` to just start a REPL associated with this project, or
;;   3. C-c C-c to build the cabal project (and start a repl session).

;; Add the current dir for loading haskell-site-file.
(add-to-list 'load-path ".")
;; Always load via this. If you contribute you should run `make all`
;; to regenerate this.
(load "haskell-mode-autoloads")

;; Customization
(custom-set-variables
 ;; Use cabal-dev for the GHCi session. Ensures our dependencies are in scope.
 '(haskell-process-type 'cabal-repl)
 '(haskell-process-path-cabal (expand-file-name "~/.cabal/bin/cabal"))
 '(haskell-process-args-cabal-repl
   '("--ghc-option=-ferror-spans"))

 ;; Use notify.el (if you have it installed) at the end of running
 ;; Cabal commands or generally things worth notifying.
 '(haskell-notify-p t)

 ;; To enable tags generation on save.
 '(haskell-tags-on-save t)

 ;; To enable stylish on save.
 '(haskell-stylish-on-save t)

 '(haskell-process-log t)
 '(haskell-process-auto-import-loaded-modules t)
 )

;; GHC mod
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

(add-hook 'haskell-mode-hook 'haskell-hook)
(add-hook 'haskell-mode-hook 'structured-haskell-mode)
(add-hook 'haskell-cabal-mode-hook 'haskell-cabal-hook)

;; Haskell main editing mode key bindings.
(defun haskell-hook ()
  (interactive-haskell-mode)

  (turn-off-haskell-simple-indent)

  ;; Load the current file (and make a session if not already made).
  (define-key haskell-mode-map [?\C-c ?\C-i] 'inferior-haskell-load-file)
  (define-key haskell-mode-map [?\C-c ?\C-l] 'haskell-process-load-file)
  (define-key haskell-mode-map [f5] 'haskell-process-load-file)

  ;; Switch to the REPL.
  (define-key haskell-mode-map [?\C-c ?\C-z] 'haskell-interactive-switch)
  ;; “Bring” the REPL, hiding all other windows apart from the source
  ;; and the REPL.
  (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)

  ;; Build the Cabal project.
  (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  ;; Interactively choose the Cabal command to run.
  (define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)

  ;; Get the type and info of the symbol at point, print it in the
  ;; message buffer.
  (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-info)

  ;; Contextually do clever things on the space key, in particular:
  ;;   1. Complete imports, letting you choose the module name.
  ;;   2. Show the type of the symbol after the space.
 ;; (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)

  ;; Jump to the imports. Keep tapping to jump between import
  ;; groups. C-u f8 to jump back again.
  (define-key haskell-mode-map [f8] 'haskell-navigate-imports)

  ;; Jump to the definition of the current symbol.
  (define-key haskell-mode-map (kbd "M-.") 'haskell-mode-tag-find)

  ;; Indent the below lines on columns after the current column.
  (define-key haskell-mode-map (kbd "C-<right>")
    (lambda ()
      (interactive)
      (forward-word)))
  ;; Same as above but backwards.
  (define-key haskell-mode-map (kbd "C-<left>")
    (lambda ()
      (interactive)
      (backward-word)))

  (add-hook 'after-save-hook 'auto-save-buffers--set-buffer-modified nil t)
  )

;; Useful to have these keybindings for .cabal files, too.
(defun haskell-cabal-hook ()
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)
  (define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-cabal-mode-map [?\C-c ?\C-z] 'haskell-interactive-switch)
  (make-local-variable 'indent-tabs-mode)
  (setq indent-tabs-mode nil)
  (setq haskell-indent-offset 2)
  (haskell-cabal-indent-line)
  )

(defun auto-save-buffers--set-buffer-modified ()
  (set-visited-file-modtime)
  (set-buffer-modified-p nil))

(add-hook 'haskell-mode-hook 'auto-save-buffers--set-buffer-modified)

(require 'el-init)
(el-init:provide)
