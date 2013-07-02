(setq browse-url-browser-function 'browse-url-generic)

(cond ((or cygwin-p windows-p windows-p)
       (setq browse-url-generic-program
             "C:\\Users\\Yokoyama\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe")
       )
      (t
       (setq browse-url-generic-program
             "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
             )
       )
      )

(require 'el-init)
(el-init:provide)
