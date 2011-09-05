;;;; YaTeX (Yet Another LaTex)
(setq YaTeX-kanji-code 0)
(defadvice yatex-mode (after yatex-mode-after-advice ())
  (set-buffer-file-coding-system 'utf-8)
  )
(ad-activate 'yatex-mode 'yatex-mode-after-advice)
;; (ad-deactivate 'yatex-mode 'yatex-mode-after-advice)

(provide 'init.yatex)