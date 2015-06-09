(require 'elixir-mode)
(require 'alchemist)

(setq alchemist-project-compile-when-needed t)

(defun elixir-mode-hook-function ()
  (setq indent-tabs-mode nil)
  )

(add-to-list 'elixir-mode-hook
             'elixir-mode-hook-function)
