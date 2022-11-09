
					; basic configuration

(setq inhibit-startup-message t)
(setq visual-bell nil)
; (setq blink-cursor-interval 0.6)
(setq use-dialog-box nil)
(setq backup-inhibited t)
(setq auto-save-default nil)
(setq vc-follow-symlinks nil)

(setq-default frame-title-format "%b %& emacs")
(setq-default indicate-empty-lines t)

; (setq maximum-scroll-margin 0.5
;       scroll-margin 99999
;       scroll-preserve-screen-position t
;       scroll-conservatively 0)

(menu-bar-mode -1)
(tool-bar-mode -1)
; (scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(recentf-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)
(electric-pair-mode 1)
(global-tab-line-mode 1)

(setq display-line-numbers-type 'relative)
(defalias 'yes-or-no-p 'y-or-n-p)

(load-theme 'modus-vivendi t)

; spell checking (with aspell)
; (setq ispell-list-command "--list")
; (flyspell-mode 1)

					; straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

; use package
(straight-use-package 'use-package)
(use-package straight :custom (straight-use-package-by-default t))

; which key
(use-package which-key
  :config
  (which-key-setup-side-window-bottom)
  (which-key-mode))

; centered cursor mode
(use-package centered-cursor-mode
  :config
  (global-centered-cursor-mode)
  )

; evil mode

(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-want-C-i-jump nil)

  :config
  (setq evil-emacs-state-cursor '("#ffffff" box))
  (setq evil-normal-state-cursor '("#ffffff" box))
  (setq evil-operator-state-cursor '("#ffffff" hollow))
  (setq evil-visual-state-cursor '("#ffffff" box))
  (setq evil-insert-state-cursor '("#ffffff" (bar . 2)))
  (setq evil-replace-state-cursor '("#ffffff" hbar))
  (setq evil-motion-state-cursor '("#ffffff" box))

  (evil-mode 1))

(evil-define-key 'normal 'global "gc" 'comment-or-uncomment-region)

(use-package evil-leader
  :config
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key "w" 'save-buffer)
  (evil-leader/set-key "q" 'save-buffers-kill-terminal)
  (evil-leader/set-key "f" 'dired)
  (evil-leader/set-key "F" 'fzf-git-files)
  (evil-leader/set-key "l" 'next-buffer)
  (evil-leader/set-key "h" 'previous-buffer)
  (evil-leader/set-key "b" 'fzf-switch-buffer)
  (evil-leader/set-key "r" 'eval-buffer) 
  ; <leader>m prefix indicates a mode
  (evil-leader/set-key "mS" 'org-tree-slide-mode)
  (evil-leader/set-key "ms" 'eshell)
  (global-evil-leader-mode)
  )

(use-package evil-snipe
  :config
  (evil-snipe-mode)
  )

; org mode
(use-package org)

(use-package evil-org
  :ensure t
  :after org
  :hook (add-hook 'org-mode-hook 'evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)
  )

; org mode presnetation
(use-package org-tree-slide
  :config
  (define-key org-tree-slide-mode-map (kbd "<f9>") 'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<f10>") 'org-tree-slide-move-next-tree)

  (setq org-tree-slide-slide-in-effect nil)
  )

; posframe
(use-package posframe :ensure t)

(use-package flycheck)

; lsp mode
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-l")
  (setq lsp-signature-function 'lsp-signature-posframe)
  :config
  (lsp-enable-which-key-integration t)
  )
(use-package lsp-ui
  :config
  (setq lsp-lens-enable nil)
  (setq lsp-ui-sideline-enable 1)
  (setq lsp-ui-sideline-show-diagnostics 1)
  (lsp-ui-doc-mode))

(define-key evil-normal-state-map "Lr" 'lsp-find-references)
(define-key evil-normal-state-map "LR" 'lsp-rename)
(define-key evil-normal-state-map "Li" 'lsp-find-implementation)
(define-key evil-normal-state-map "Ld" 'lsp-find-definition)
(define-key evil-normal-state-map "Lx" 'lsp-execute-code-action)
(define-key evil-normal-state-map "Lf" 'lsp-format-buffer)
(define-key evil-normal-state-map "LF" 'lsp-format-region)
(define-key evil-normal-state-map "K" 'lsp-describe-thing-at-point)

(use-package company
  :ensure t
  :hook ((emacs-lisp-mode . (lambda ()
			      (setq-local company-backends '(company-elisp))))
	 (emacs-lisp-mode . company-mode)
	 )
  :config
  (setq company-idle-delay 0.1
	company-minimum-prefix-length 1)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  )

(use-package rustic)
(use-package yaml-mode)
(use-package ccls
  :hook ((c-mode c++-mode) .
         (lambda () (require 'ccls) (lsp))))

; command log mode
; (use-package command-log-mode)

(use-package fzf)

; snippets
(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.config/emacs/snippets"))
  (yas-global-mode 1))

(yas-define-snippets 'latex-mode '(
    ("im" "\$$0\$" "inline math mode")
    ("sin" "\\sin($1)$0" "sin")
    ("sec" "\\section($1)$0" "section")
    ("ssec" "\\subsection($1)$0" "subsection")
    ("set" "\\{ $1 \\}$0" "set")
    (".." "\\ldots" "elipses")
))
