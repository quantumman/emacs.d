(require 'android-mode)

;; Android SDKのパス
;; (setq android-mode-sdk-dir (getenv "ANDROID_HOME"))
(setq android-mode-sdk-dir (expand-file-name "~/Devel/Android/sdk"))

;; コマンド用プレフィックス
;; ここで設定したキーバインド＋android-mode.elで設定された文字、で、各種機能を利用できます
(setq android-mode-key-prefix (kbd "C-c C-c"))

;; デフォルトで起動するエミュレータ名
(setq android-mode-avd "AVD_01")

(add-hook 'android-mode-hook
          '(lambda ()
             (guide-key/add-local-guide-key-sequence "C-c C-c")
             (guide-key/add-local-highlight-command-regexp "org-")
             ))

(require 'el-init)
(el-init:provide)
