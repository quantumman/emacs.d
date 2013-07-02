(require 'web-mode)

;;; emacs 23以下の互換
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;;; インデント数
(defun web-mode-default-indent-depth ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   0)
  (setq web-mode-css-offset    0)
  (setq web-mode-script-offset 0)
  (setq web-mode-php-offset    0)
  (setq web-mode-java-offset   0)
  (setq web-mode-asp-offset    0))

(add-hook 'web-mode-hook
          (lambda ()
            (local-set-key (kbd "<return>") 'newline)
            (case (intern (file-name-extension (buffer-file-name)))
             (aspx
              (setq indent-tabs-mode t
                    tab-width 4))
             (otherwise
              (web-mode-default-indent-depth)
              ))))
