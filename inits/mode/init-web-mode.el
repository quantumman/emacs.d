(require 'web-mode)

;;; emacs 23以下の互換
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'"    . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'"    . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\"      . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\"        . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'"  . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))


;;; インデント数
(defun web-mode-default-indent-depth ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   2
        web-mode-css-offset    2
        web-mode-script-offset 2
        web-mode-php-offset    2
        web-mode-java-offset   2
        web-mode-asp-offset    2
        ))
(defun web-mode-asp-indent ()
  "Indentation setting for Web mode."
  (setq indent-tabs-mode t
        tab-width 4
        web-mode-html-offset   4
        web-mode-css-offset    4
        web-mode-script-offset 4
        web-mode-asp-indent    4
        web-mode-code-indent-offset 4
        web-mode-markup-indent-offset 4
        ))

(add-hook 'web-mode-hook
          (lambda ()
            (local-set-key (kbd "<return>") 'newline)
            (case (intern (file-name-extension (buffer-file-name)))
              ((aspx ascx)
               (web-mode-asp-indent))
              (otherwise
               (web-mode-default-indent-depth)
               ))))

(require 'el-init)
(el-init:provide)
