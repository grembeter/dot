;;; init.el

;; ============================
;; MELPA package support
;; ============================

(require 'package)
(package-initialize)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(when (not package-archive-contents)
  (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

;; ============================
;; basic customization
;; ============================

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file)

;; inhibit the startup screen
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; helps to disable cursor blinking
(setq visible-cursor nil)

;; keyboard scroll one line at a time
(setq scroll-step 1
      scroll-margin 4
      scroll-conservatively 10000)

;; Monday is the 1st day
(setq calendar-week-start-day 1)

;; don't use the compiled code if its the older package
(setq load-prefer-newer t)

;; backup all files into one directory
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

;; use spaces by default
(setq-default tab-width 4
              indent-tabs-mode nil)

;; visually indicate empty lines after the buffer end
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;; do not show tool bar
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; do not show scroll bar
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; do not show menu bar
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

(save-place-mode 1)

(column-number-mode t)

;; makes killing/yanking interact with the clipboard
(setq-default x-select-enable-clipboard t)

;; Save clipboard strings into kill ring before replacing them. When
;; one selects something in another program to paste it into Emacs, but
;; kills something in Emacs before actually pasting it, this selection
;; is gone unless this variable is non-nil.
(setq-default save-interprogram-paste-before-kill t)

;; shows all options when running apropos
(setq-default apropos-do-all t)

;; mouse yank commands yank at point instead of at click
(setq-default mouse-yank-at-point t)

;; single character is enough, SPC also means yes, and DEL means no,
;; fset is for where global substitution is the right thing to do
(fset 'yes-or-no-p 'y-or-n-p)

;; superior rectangle handling but with the standard
;; kill/copy/yank/undo interface
(cua-selection-mode t)

;; unbind `suspend-frame` to avoid accidentally iconify emacs
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-x w") 'revert-buffer)

;; delete whitespace just when a file is saved
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; enable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(defun toggle-comment-on-line ()
  "Comment or uncomment current line."
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))

(global-set-key (kbd "C-;") 'toggle-comment-on-line)

;; toggle Display-Line-Numbers mode in all buffers
;; (global-display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; set cross environment
(setenv "PATH" (concat
                "/opt/gcc-arm-none-eabi/bin" ":"
                (getenv "PATH")))

(require 'use-package)

(use-package ispell
  :ensure t
  :config
  (setq ispell-program-name "hunspell")
  ;; (setq-default ispell-local-dictionary "en_US")
  ;; (setq-default ispell-local-dictionary-alist
  ;;               '(("en_US" "[[:alpha:]]" "[^[:alpha:]]"
  ;;                  "[']" nil ("-d" "en_US,de_DE,de_CH,uk_UA")
  ;;                  nil utf-8)))
  :bind
  (("C-c w" . 'ispell-word)
   ("C-c r" . 'ispell-region)
   ("C-c b" . 'ispell-buffer)))

(use-package ujelly-theme
  :ensure t
  :config
  (load-theme 'ujelly t)
  ;; highlight current line in all buffers
  (global-hl-line-mode t)
  ;; give a chance for emacsclient
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (select-frame frame)
              (when (display-graphic-p frame)
                (load-theme 'ujelly t)))))

(use-package company
  :ensure t
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))

(use-package delight
  :ensure t
  :delight)

(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
  :delight)

(use-package recentf
  :ensure t
  :config
  (setq recentf-auto-cleanup 'never
        recentf-max-saved-items 1000
        recentf-save-file (concat user-emacs-directory ".recentf"))
  (recentf-mode t)
  :delight)

(use-package ibuffer
  :ensure t
  :bind ("C-x C-b" . ibuffer)
  :delight)

(use-package projectile
  :ensure t
  :config
  ;; use it everywhere
  (projectile-mode t)
  :bind ("C-x f" . projectile-find-file)
  :delight)

(use-package python
  :ensure t
  :custom
  (python-indent-offset 4)
  :delight)

(use-package rainbow-delimiters
  :ensure t
  :config
  (show-paren-mode 1)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  :delight)

(use-package highlight-symbol
  :ensure t
  :config
  (set-face-background 'highlight-symbol-face (face-background 'highlight))
  (setq highlight-symbol-idle-delay 0.5)
  (add-hook 'prog-mode-hook 'highlight-symbol-mode)
  :bind (("M-n" . highlight-symbol-next)
         ("M-p" . highlight-symbol-prev))
  :delight)

(use-package flyspell
  :ensure t
  :config
  ;; Flyspell should be able to learn a word without the
  ;; `flyspell-correct-word-before-point` pop up.
  ;; Refer:
  ;; https://stackoverflow.com/questions/22107182/in-emacs-flyspell-mode-how-to-add-new-word-to-dictionary
  (defun flyspell-learn-word-at-point ()
    "Add word at point to list of correct words."
    (interactive)
    (let ((current-location (point))
          (word (flyspell-get-word)))
      (when (consp word)
        (flyspell-do-correct 'save nil
                             (car word) current-location
                             (cadr word) (caddr word)
                             current-location))))

  ;; This color is specific to `nord` theme.
  ;; (set-face-attribute 'flyspell-incorrect nil :underline '(:style line :color "#bf616a"))
  ;; (set-face-attribute 'flyspell-duplicate nil :underline '(:style line :color "#bf616a"))

  :bind ("H-l" . flyspell-learn-word-at-point)
  :delight)

;; display possible completions at all places
(use-package ido-completing-read+
  :ensure t
  :config
  ;; This enables ido in all contexts where it could be useful, not just
  ;; for selecting buffer and file names
  (ido-mode t)
  (ido-everywhere t)
  ;; This allows partial matches, e.g. "uzh" will match "Ustad Zakir Hussain"
  (setq ido-enable-flex-matching t)
  (setq ido-use-filename-at-point nil)
  ;; Includes buffer names of recently opened files, even if they're not open now.
  (setq ido-use-virtual-buffers t)
  :diminish nil)

(use-package gitconfig
  :ensure t
  :load-path "pkgs"
  :config
  (add-hook 'gitconf-mode-hook
            (lambda ()
              (setq indent-line-function #'insert-tab
                    indent-tabs-mode t))))

(use-package cc-mode
  :ensure nil
  :config
  (defconst gr/c-style
    '((c-backslash-column . 80)
      (c-backslash-max-column . 100)
      (c-basic-offset . 4)
      (c-continued-statement-offset 4)
      (c-echo-syntactic-information-p . t)
      (c-offsets-alist .
                       ((inextern-lang . 0)
                        (substatement . 0)
                        (statement-case-intro . +)
                        (substatement-open . 0)
                        (case-label . +)
                        (block-open . 0))))
    "C programming style")
  (defun gr/c-mode-common-hook ()
    (setq c-tab-always-indent t)
    (setq c-indent-level 4)               ;; a TAB is equivilent to four spaces
    (setq c-indent-tabs-mode t)           ;; pressing TAB causes indentation
    (setq c-argdecl-indent 0)             ;; do not indent argument decl's extra
    (setq comment-fill-column 120)
    (setq comment-column 79)
    (global-set-key (kbd "<f7>") 'compile)
    (c-set-style "gr")                    ;; custom c-style
    (c-toggle-hungry-state 1))            ;; hungry delete
  (c-add-style "gr" gr/c-style)
  (add-hook 'c-mode-common-hook 'gr/c-mode-common-hook)
  (add-hook 'c++-mode-common-hook 'gr/c-mode-common-hook))

(use-package org
  :ensure nil
  :bind (("C-c a" . org-agenda)
         :map org-mode-map
         ("C-u C-c C-l" . org-toggle-link-display))
  :config
  (setq org-hide-leading-stars t
        org-agenda-files
        (append (directory-files-recursively "~/def" "org$")))
  (add-hook 'org-mode-hook
            (lambda ()
              (display-line-numbers-mode -1))))

(use-package org-journal
  :ensure t
  :bind ("<f8>" . org-journal-new-entry)
  :commands (org-journal-new-entry)
  :config
  (setq org-journal-dir "~/def"
        org-journal-file-format "%Y%m%d.txt"
        org-journal-date-format "%A, %d %B %Y"))

(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)))

(use-package rust-mode)

(use-package deft
  :bind ("<f9>" . deft)
  :commands (deft)
  :config
  (setq deft-directory "~/def"
        deft-recursive t
        deft-auto-save-interval 10.0
        deft-extensions '("org" "rst" "txt")))
