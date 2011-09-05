;; objective-c
(add-to-list 'auto-mode-alist '("\\.mm?$" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@implementation" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@interface" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@protocol" . objc-mode))
;; Jave
;; (add-to-list 'auto-mode-alist '("\\.java$" . jde-mode))

(provide 'init.objective-c-mode)