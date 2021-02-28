
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(let ((minver "24.1"))
    (when (version<= emacs-version minver)
	      (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version<= emacs-version "24.4")
    (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'zenburn t)

;; Put backup files neatly away
(let ((backup-dir "/mnt/hdd/var/emacs/backup/")
      (auto-saves-dir "/mnt/hdd/var/emacs/auto-saves/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks
      delete-old-versions t  ; Clean up the backups
      version-control t      ; Use version numbers on backups,
      kept-new-versions 5    ; keep some new versions
      kept-old-versions 2)   ; and some old ones, too
;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
(require 'init-socks) ;; socks proxy
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-org)      ;;


;; use xclip to copy/paste in emacs-nox
(unless window-system
  (when (getenv "DISPLAY")
	(defun xclip-cut-function (text &optional push)
	  (with-temp-buffer
		(insert text)
		(call-process-region (point-min) (point-max) "xclip" nil 0 nil "-i" "-selection" "clipboard")))
	(defun xclip-paste-function()
	  (let ((xclip-output (shell-command-to-string "xclip -o -selection clipboard")))
		(unless (string= (car kill-ring) xclip-output)
		  xclip-output )))
	(setq interprogram-cut-function 'xclip-cut-function)
	(setq interprogram-paste-function 'xclip-paste-function)
	))

;;(set-default-font "-PfEd-Inconsolata-normal-normal-normal-*-19-*-*-*-m-0-iso10646-1")

(provide 'init)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org gnu-elpa-keyring-update fullframe seq ggtags sqlite ssh org-ehtml htmlize markdown-mode sqlplus org-plus-contrib ##)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; save cursour position
(require 'saveplace)
(setq-default save-place t)
