;;;; calendar
(require 'calfw)
(unless  (fboundp 'calendar-extract-month)
  (defalias 'calendar-extract-month (symbol-function 'extract-calendar-month))
  (defalias 'calendar-extract-year  (symbol-function 'extract-calendar-year))
  (defalias 'calendar-extract-day   (symbol-function 'extract-calendar-day)))

;;;; with org-mode
(require 'calfw-org)

;;;; with
(require 'calfw-ical)
;; (setq google-cal "http://www.google.com/calendar/ical/quantumcars%40gmail.com/private-939d157a333f31b3912bfb55e751ac98/basic.ics")
;; (setq cfw:ical-calendar-contents-sources '(google-cal))
;; (setq cfw:ical-calendar-annotations-sources '(goolge-cal))
(defun open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :view 'month
   :contents-sources
   (list
    (cfw:org-create-source "Seagreen4")
    (cfw:ical-create-source "Google Calendar" "https://www.google.com/calendar/ical/quantumcars%40gmail.com/private-939d157a333f31b3912bfb55e751ac98/basic.ics" "#2952a3")
    )))

;;;; with howm
(require 'howm)
(require 'calfw-howm)
(cfw:install-howm-schedules)
(define-key howm-mode-map (kbd "M-C") 'cfw:open-howm-calendar)

(auto-install-from-url "https://raw.github.com/kiwanami/emacs-calfw/master/calfw-howm.el")
(provide 'init.calendar)