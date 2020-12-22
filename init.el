;; init.el

;; ============================
;; MELPA package support
;; ============================

;; enable basic packaging support

(require 'package)

;; add the Melpa archive to the list
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; init the package infrastructure
(package-initialize)

;; if there is no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; install packages
(defvar my-packages
  '(better-defaults                     ;; set up some better emacs defaults
    dired-single                        ;; reuse the current dired
                                        ;; buffer to visit a directory
    elpy                                ;; emacs lisp python environment
    flycheck                            ;; on the fly syntax checking
    ample-theme				;; material-theme
    ggtags                              ;; GNU Global
    py-autopep8                         ;; run autopep8 on save
    blacken                             ;; black formatting on save
    magit                               ;; git integration
    deft                                ;; mode for quickly browsing
    winner                              ;; undo and redo window configuration
    markdown-mode                       ;; covers Markdown syntax
    org-bullets))                       ;; replace all headline markers
                                        ;;   with different Unicode bullets

;; scans the list in my-packages and install required
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      my-packages)

;; ============================
;; basic customization
;; ============================

(require 'better-defaults)
(setq inhibit-startup-message t)        ;; hide the startup message
(load-theme 'ample t)			;; load theme
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq scroll-step 1)                    ;; keyboard scroll one line at a time
(setq scroll-conservatively 10000)
(setq scroll-margin 4)

;; ============================
;; development customization
;; ============================

;; enable elpy
(elpy-enable)
(setq elpy-rpc-python-command "python3")

;; enable flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; enable flyspell
(setq text-mode-hook '(lambda() (flyspell-mode t)))
(setq flyspell-issue-message-flag nil)

;; enable dired-single
(require 'dired-single)
(defun gr-dired-init ()
  "Remap dired keys"
  (define-key dired-mode-map [return] 'dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
  (define-key dired-mode-map "^"
    (function
     (lambda nil (interactive) (dired-single-buffer "..")))))

(if (boundp 'dired-mode-map)
    (gr-dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'gr-dired-init))

;; Monday is the 1st day
(setq calendar-week-start-day 1)

;; enable winner-mode
(winner-mode 1)

;; 
(defun gr/vc-mode-hook ()
  (message buffer-file-name)
  (when
      (and
       (file-exists-p (buffer-file-name))
       (stringp buffer-file-name)
       (or (string-equal "/home/gr/.emacs.d/init.el" buffer-file-name)
           (string-equal "/home/gr/.gitconfig" buffer-file-name)
           (string-equal "/home/gr/.vimrc" buffer-file-name)
           (string-equal "/home/gr/.Xresources" buffer-file-name)
           (string-equal "/home/gr/.zalias" buffer-file-name)
           (string-equal "/home/gr/.zshrc" buffer-file-name))
       (setq-local vc-follow-symlinks t))))
(add-hook 'find-file-hook 'gr/vc-mode-hook)

(autoload 'gtags-mode "gtags" "" t)
;; provide the default key binding
(setq gtags-suggested-key-mapping t)

;; ============================
;; user details
;; ============================

(load "~/.config/emacs" t)

;; ============================
;; indentation
;; ============================

(setq tab-width 4)

;; ============================
;; yes or no
;; ============================

(defalias 'yes-or-no-p 'y-or-n-p)

;; ============================
;; empty lines
;; ============================

(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;; ============================
;; marking text
;; ============================

(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; ============================
;; autopair
;; ============================

(electric-pair-mode t)

;; ============================
;; notmuch
;; ============================

(autoload 'notmuch "notmuch" "notmuch mail" t)

;; ============================
;; spelling
;; ============================

(executable-find "aspell")
(setq ispell-program-name "aspell")
(setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))

;; ============================
;; cursor
;; ============================

(blink-cursor-mode 0)
(setq visible-cursor nil)

;; ============================
;; deft
;; ============================

(setq deft-directory "~/o")
(setq deft-recursive t)

;; ============================
;; org
;; ============================

(setq org-hide-emphasis-markers nil)
(add-hook 'org-mode-hook
          (lambda ()
            (org-bullets-mode 1)))

(setq org-publish-project-alist
      `(("index"
         :with-title nil :base-directory "~/o/"
         :base-extension "org" :publishing-directory "~/o/html/"
         :headline-levels 3 :section-numbers nil
         :publishing-function org-html-publish-to-html :with-toc nil
         :html-head-include-default-style nil
         :html-head-include-scripts nil
         :html-preamble nil :html-postamble t)))

;; ============================
;; auto-mode-alist
;; ============================

(add-to-list 'auto-mode-alist '("\\.bb\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.bbappend\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.bbclass\\'" . python-mode))

;; ============================
;; c-mode
;; ============================

(defconst gr/c-style
  '((c-backslash-column . 80) 
    (c-backslash-max-column . 100)
    (c-basic-offset . 4)
    (c-continued-statement-offset 4)
    (c-echo-syntactic-information-p . t)
    (c-offsets-alist .
		     ((inextern-lang . 0)
		      (substatement . 0)
		      (statement-case-intro . 0)
		      (substatement-open . 0)
		      (case-label . +)
		      (block-open . 0))))
  "C programming style")
(c-add-style "gr" gr/c-style)

(defun gr/c-mode-common-hook ()
  (setq c-tab-always-indent t)
  (setq c-indent-level 4)               ;; a TAB is equivilent to four spaces
  (setq c-indent-tabs-mode t)           ;; pressing TAB causes indentation
  (setq c-argdecl-indent 0)             ;; do not indent argument decl's extra
  (setq comment-fill-column 120)
  (setq comment-column 79)
  (gtags-mode 1)
  (c-set-style "gr")                    ;; custom c-style
  (c-toggle-hungry-state 1))            ;; hungry delete
(add-hook 'c-mode-common-hook 'gr/c-mode-common-hook)
(add-hook 'c++-mode-common-hook 'gr/c-mode-common-hook)

(global-linum-mode t)
(setq linum-format
      (lambda (line)
        (propertize
         (format
          (let
              ((w (length
                   (number-to-string (count-lines (point-min) (point-max))))))
            (concat "%" (number-to-string w) "d "))
          line)
         'face 'linum)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (markdown-mode org-bullets deft magit blacken py-autopep8 ggtags ample-theme flycheck elpy better-defaults)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
