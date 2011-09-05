;;;; anything books
(require 'anything-books)
(setq abks:books-dir (expand-file-name "~/Dropbox/Books"))

(when linux-p (setq abks:open-command "evince"))
(when (or darwin-p ns-p carbon-p)
  (setq abks:open-command "/Applications/Preview.app/Contents/MacOS/Preview"))
(when windows-p (setq abks:open-command "acroread"))

;; Evince Setting
(setq abks:cache-pixel "600")
(setq abks:mkcover-cmd-pdf-postfix nil)
(setq abks:mkcover-cmd '("evince-thumbnailer" "-s" size pdf jpeg))

;; key bind for anything-books
(global-set-key )
