;;;
(require 'csharp-mode)
(push '("\\.cs$" . csharp-mode) auto-mode-alist)

(defvar yas/menu-keymap yas/minor-mode-menu)
(defalias 'yas/snippet-table-fetch 'yas/fetch)
(defalias 'yas/snippet-table 'yas/snippet-table-get-create)
(defalias 'yas/menu-keymap-for-mode 'yas/menu-keymap-get-create)

(provide 'init.csharp-mode)