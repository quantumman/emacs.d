;;;; Key bindings
;; Define the move point to top line of window

;; Define the move point to bottom line of window


(define-region-key global-map "\C-w" 'kill-region 'ispell-word)
(define-region-key global-map [C-tab] 'indent-region 'indent-for-tab-command)

(global-set-key "\C-f" 'forward-word)
(global-set-key "\C-b" 'backward-word)

(provide 'init.custom-key-binding)
