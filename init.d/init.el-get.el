;;;; el-get.el
;; (save-window-excursion (shell-command (format "emacs-test -l %s %s &" buffer-file-name buffer-file-name)))
(add-to-list 'load-path "~/.emacs.d/el-get/el-get/")
(require 'el-get)
(load "2010-12-09-095707.el-get-ext.el")
;; 初期化ファイルのワイルドカードを指定する
(setq el-get-init-files-pattern (expand-file-name "~/.emacs.d/init.el"))
(setq el-get-sources (el-get:packages))
(el-get)


(provide 'init.el-get)