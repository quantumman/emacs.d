(require 'ansi-color)
(require 'env-test)
(require 'eshell)

(custom-set-variables
 ;; '(eshell-ask-to-save-history (quote always))
 ;; '(eshell-history-size 1000)
 ;; '(eshell-ls-dired-initial-args (quote ("-h")))
 ;; '(eshell-ls-exclude-regexp "~\\'")
 ;; '(eshell-ls-initial-args "-h")
 ;; '(eshell-ls-use-in-dired t nil (em-ls))
 ;; '(eshell-modules-list (quote (eshell-alias eshell-basic
 ;;                                           eshell-cmpl eshell-dirs eshell-glob
 ;;                                           eshell-hist eshell-ls eshell-pred
 ;;                                           eshell-prompt eshell-rebind
 ;;                                           eshell-script eshell-smart
 ;;                                           eshell-term eshell-unix eshell-xtra)))
 '(eshell-output-filter-functions
   '(eshell-handle-control-codes
     eshell-watch-for-password-prompt
     eshell-postoutput-scroll-to-bottom
     eshell-handle-ansi-color))
 '(eshell-preoutput-filter-functions
   '(ansi-color-filter-apply))
 '(eshell-scroll-show-maximum-output t)
 '(eshell-scroll-to-bottom-on-output nil)
 '(eshell-prefer-to-shell t nil (eshell))
 '(eshell-stringify-t nil)
 '(eshell-term-name "ansi")
 '(eshell-visual-commands (quote ("git" "vi" "top" "screen" "less" "lynx"
                                  "ssh" "rlogin" "telnet" "diff")))
 )

;; (setenv "PATH" "/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/home/Quantumman/.cabal/bin")
;; (if (or carbon-p cocoa-p)
;;     (setenv "EDITOR" "open -a emacs")
;;   (setenv "EDITOR" "emacsclient")
;;   )
;; (setenv "LC_ALL" "C")
;; (setenv "LANG" "ja_JP.UTF8")

;;;; Prompt
(defun pcomplete/sudo ()
  "complete a command after sudo command."
  (interactive)
  (let ((pcomplete-help "complete after sudo"))
    (pcomplete-here (pcomplete-here (eshell-complete-commands-list )))))

(defun eshell:string-shorten (source-string upper-length)
  (when (stringp source-string)
    (if (< upper-length (length source-string))
        (concat (substring source-string 0 (- upper-length 3)) "...")
      source-string
      )))

(defun eshell:replace-prefix-match-string (source-string from-string to-string)
  (when (and (stringp source-string)
             (stringp from-string)
             (stringp to-string))
    (when (string-match from-string source-string)
      (replace-match to-string nil nil source-string))))

(defun eshell:relative-file-path ()
  (let ((absolute-path (eshell/pwd))
        (home (getenv "HOME")))
    (if (string= absolute-path home)
        "~/"
      (eshell:replace-prefix-match-string absolute-path home "~")
      )))

(defun eshell:git-current-branch ()
  (substring
   (shell-command-to-string "git branch | grep \"*\" | sed \"s/\"*\" //\"")
   0 -1 ))

(defun custom:eshell-prompt-function ()
  (let ((hostname (car (split-string (system-name) "\\.")))
        (absolute-current-path (eshell/pwd)))
    (format "%s@%s: %s %s\n%s "
            (getenv "USER")
            hostname
            (eshell:relative-file-path)
            (if (file-exists-p (concat (eshell/pwd) "/" ".git"))
                (concat "(" (eshell:git-current-branch) ")")
              "")
            (if (= (user-uid) 0) "#" "$"))))

(setq eshell-prompt-function #'custom:eshell-prompt-function)
(setq eshell-prompt-regexp
      (mapconcat
       #'(lambda (str) (concat "\\(" str "\\)"))
       '("^[^#$\n]* [#$] "                    ; default
         "^\\(mysql\\|[ ]\\{4\\}[-\"'`]\\)> "
         "^>>> "                              ; python
         "^ftp> "
         "^[^#$\n]*\n\s:\s.*\n[#$] "
         "^[#$]> "
         "^[#$] "
         ".*\n[#$] "
         )
       "\\|"))


;;;; Buffer Clear
(defun eshell/clear ()
  "Clear the current buffer, leaving one prompt at the top."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    ))

;; 補完時に大文字小文字を区別しない
(setq eshell-cmpl-ignore-case t)
;; 確認なしでヒストリ保存
(setq eshell-ask-to-save-history (quote always))
;; 補完時にサイクルする
(setq eshell-cmpl-cycle-completions t)
;;補完候補がこの数値以下だとサイクルせずに候補表示
;; (setq eshell-cmpl-cycle-cutoff-length 5)
;; 履歴で重複を無視する
(setq eshell-hist-ignoredups t)

;;(set-face-background 'eshell-prompt-face "Black")
;;(set-face-foreground 'eshell-prompt-face "Green")


;; OMG! eshell defines its own mode-map when eshell-mode is called...
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (progn
                (define-key eshell-mode-map (kbd "\C-cl") 'eshell/clear)
                (define-key eshell-mode-map (kbd "\C-r") 'eshell-previous-matching-input)
                (define-key eshell-mode-map [up] 'eshell-previous-input)
                (define-key eshell-mode-map [down] 'eshell-next-input)

                (setenv "LANG" "ja_JP.UTF-8")

                (linum-mode -1)

                (whitespace-mode 0)

                (hl-line-mode 0)
                )
              ))

(provide 'init.eshell)
