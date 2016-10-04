(require 'elixir-mode)
(require 'alchemist)
(require 'smartparens)
(require 'yasnippet)

(sp-with-modes '(elixir-mode)
  (sp-local-pair "fn" "end"
         :when '(("SPC" "RET"))
         :actions '(insert navigate))
  (sp-local-pair "do" "end"
         :when '(("SPC" "RET"))
         :post-handlers '(sp-ruby-def-post-handler)
         :actions '(insert navigate)))

(setq alchemist-project-compile-when-needed t
      alchemist-mix-command (executable-find "mix")
      alchemist-iex-program-name (executable-find "iex")
      alchemist-execute-command (executable-find "elixir")
      alchemist-compile-command (executable-find "elixirc")
      )

(defun elixir-mode-hook-function ()
  (setq indent-tabs-mode nil)
  (setq company-quickhelp-delay nil)
  (alchemist-mode)
  (smartparens-mode)
  (yas/minor-mode)
  )

(add-to-list 'elixir-mode-hook
             'elixir-mode-hook-function)

(require 'el-init)
(el-init-provide)
