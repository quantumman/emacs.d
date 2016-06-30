(require 'web-mode)
(require 'tern)

(eval-after-load 'flycheck
  '(custom-set-variables
    '(flycheck-disable-checkers '(javascript-jshint javascript-jscs))
    ))

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
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.msx\\'" . web-mode))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        ad-do-it)
    ad-do-it))

(add-to-list 'web-mode-content-types '("jsx" . "\\.jsx?\\'"))

;;; インデント数
(defun web-mode-default-indent-depth ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        tab-width 2
        indent-tabs-mode nil
        ))
(defun web-mode-asp-indent ()
  "Indentation setting for Web mode."
  (setq indent-tabs-mode t
        tab-width 4
        web-mode-code-indent-offset 4
        web-mode-markup-indent-offset 4
        web-mode-css-indent-offset 2
        ))

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
  (local-set-key (kbd "<return>") 'newline)

  (when (string-equal "tsx" (file-name-extension buffer-file-name))
    (require 'flycheck-typescript-tslint)
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (company-mode-on))

  (when (equal web-mode-content-type "jsx")
    (flycheck-add-mode 'javascript-eslint 'web-mode)
    (flycheck-mode)
    (tern-mode t))

 (setq indent-tabs-mode nil
        web-mode-enable-auto-paring t
        web-mode-enable-css-colorization t
        web-mode-enable-part-face t
        web-mode-enable-comment-keywords t
        web-mode-enable-current-element-highlight t
        web-mode-enable-current-column-highlight t
        )
  (case (intern (file-name-extension (buffer-file-name)))
    ((aspx ascx)
     (web-mode-asp-indent))
    (otherwise
     (web-mode-default-indent-depth)
     )))

(add-hook 'web-mode-hook 'web-mode-hook-function)

(require 'el-init)
(el-init-provide)
