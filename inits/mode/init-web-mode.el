(require 'web-mode)

;;; emacs 23以下の互換
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'"    . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'"    . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'"      . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'"        . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'"  . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))


;;; インデント数
(defun web-mode-default-indent-depth ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-php-offset    2
        web-mode-java-offset   2
        web-mode-asp-offset    2
        web-mode-style-padding 2
        web-mode-script-padding 2
        web-mode-block-padding 2
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

(setq web-mode-enable-auto-paring t
      web-mode-enable-css-colorization t
      web-mode-enable-part-face t
      web-mode-enable-comment-keywords t
      web-mode-enable-current-element-highlight nil
      )

(require 'emmet-mode)
(require 'ac-emmet)
(require 'ac-js2)
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)
(setq ac-source-emmt-html
      (append ac-source-emmet-html-snippets
              ac-source-emmet-html-aliases)
      )
(setq web-mode-ac-sources-alist
      '(("php" . (ac-source-yasnippet ac-source-php-auto-yasnippets))
        ("html" . (ac-source-emmet-html-aliases ac-source-emmet-html-snippets))
        ("css" . (ac-source-css-property ac-source-emmet-css-snippets))
        ("javascript" . (ac-source-js2))
        ))
(defun web-mode-on-before-auto-complete-hooks-function ()
  (let ((web-mode-cur-language
         (web-mode-language-at-pos)))
    (if (string= web-mode-cur-language "php")
        (yas-activate-extra-mode 'php-mode)
      (yas-deactivate-extra-mode 'php-mode))
    (if (string= web-mode-cur-language "css")
        (setq emmet-use-css-transform t)
      (setq emmet-use-css-transform nil)))
  )
(add-hook 'web-mode-before-auto-complete-hooks 'web-mode-on-before-auto-complete-hooks-function)

(defun web-mode-hook-function ()
  (lambda ()
    (local-set-key (kbd "<return>") 'newline)
    (setq indent-tabs-mode nil)
    (case (intern (file-name-extension (buffer-file-name)))
      ((aspx ascx)
       (web-mode-asp-indent))
      (otherwise
       (web-mode-default-indent-depth)
       )))
  )
(add-hook 'web-mode-hook 'web-mode-hook-function)

(require 'el-init)
(el-init:provide)
