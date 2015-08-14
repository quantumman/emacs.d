(require 'elixir-mode)
(require 'alchemist)

(setq alchemist-project-compile-when-needed t
      alchemist-mix-command (executable-find "mix")
      alchemist-iex-program-name (executable-find "iex")
      alchemist-execute-command (executable-find "elixr")
      alchemist-compile-command (executable-find "elixirc")
      )

(defun elixir-mode-hook-function ()
  (setq indent-tabs-mode nil)
  (alchemist-mode)
  )

(add-to-list 'elixir-mode-hook
             'elixir-mode-hook-function)
