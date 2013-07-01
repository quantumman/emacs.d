;;;; twitter
;; (setq browse-url-browser-function 'browse-url-generic
;;       browse-url-generic-program "google-chrome")
;;;; twitter
(setq browse-url-browser-function 'browse-url-generic)
(cond ((or cygwin-p windows-p)
       (setq browse-url-generic-program
        "C:\\Users\\Yokoyama\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe")
       )
      (t
       (setq browse-url-generic-program
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
        )
       )
      )



(require 'twittering-mode)
(twittering-icon-mode t)
(setq twittering-retweet-format "RT @%s: %t")
;; (setq twittering-status-format
;;       "%C{%Y/%m/%d %H:%M:%S} %s > %T // from %f%L%r%R")
;; (load-file (expand-file-name "~/.emacs.d/twitter-password.el"))
(setq twittering-username "_quantumman_")
;; (setq twittering-password twitter-password)

(setq twittering-use-master-password t)

(setq twittering-update-status-function
      'twittering-update-status-from-pop-up-buffer)
;; (setq twittering-auth-method 'xauth)
(add-hook 'twittering-mode-hook '(lambda () (global-hl-line-mode 0)))

(provide 'init.twitter)
