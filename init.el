(setq gc-cons-threshold 100000000)

;; Some local variables for per system config
(defvar-local font-size 100)
(defvar-local spelling-reg "en_US")

(cond
 ((string= system-type "windows-nt")
  (add-to-list 'exec-path "C:/hunspell/hunspell-1.3.2-3-w32-bin/bin")
  (setq font-size 110))
 ((string= system-type "gnu/linux")
  (setq font-size 100))
 ((string= system-type "darwin")
  (add-to-list 'exec-path "/usr/local/bin")
  (setq spelling-reg "en_CA")
  (setq font-size 120)))

;;; Packages

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms

(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;; General set ups

;; Remove the echo from CMD
;; (defun my-comint-init ()
;;  (setq comint-process-echoes t))
;;(add-hook 'comint-mode-hook 'my-comint-init)

(customize-set-variable 'tramp-default-method "ssh")

(tool-bar-mode -1)
(setq visible-bell t)
(setq inhibit-startup-message t)
(set-face-attribute 'default nil :font "DejaVu Sans Mono" :height font-size)
(global-linum-mode t)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 2))

(use-package doom-themes
  :init (load-theme 'doom-dark+ t))

;;; ORG Mode

(use-package org-roam
  :ensure t
  :defer t
  :custom
  (org-roam-directory "~/Notes/Roam/")
  (org-roam-dailies-directory "Journal/")
  :bind (("C-c n l"   . org-roam-buffer-toggle)
         ("C-c n f"   . org-roam-node-find)
	 ("C-c n d"   . org-roam-dailies-goto-date)
	 ("C-c n c"   . org-roam-dailies-capture-today)
	 ("C-c n C r" . org-roam-dailies-capture-tomorrow)
	 ("C-c n t"   . org-roam-dailies-goto-today)
	 ("C-c n y"   . org-roam-dailies-goto-yesterday)
	 ("C-c n r"   . org-roam-dailies-goto-tomorrow)
	 ("C-c n g"   . org-roam-graph)
	 ("C-c n i"   . org-roam-node-insert))
  :config
  (org-roam-db-autosync-enable))

(use-package org
  :bind (("C-c a" . org-agenda))
  :config 
    (setq org-todo-keywords
	  '((sequence "TODO" "BLOCKED" "VERIFY" "|" "DONE" "DELEGATED")))
    (setq org-log-done t))

;;; Spelling

(use-package flyspell
  :hook
  (text-mode . flyspell-mode)
  (prog-mode . flyspell-prog-mode))

(setq ispell-program-name (locate-file "hunspell"
    exec-path exec-suffixes 'file-executable-p))

(setq ispell-local-dictionary spelling-reg)

(setq ispell-local-dictionary-alist
      `((,spelling-reg "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" ,spelling-reg) nil utf-8)))

;;; General Programming

(use-package flycheck
  :init (global-flycheck-mode 1)
  :config
  (setq flycheck-python-flake8-executable "C:/Users/sesa638306/AppData/Local/Programs/Python/Python37/Scripts/flake8.exe"))

(use-package swiper)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l"
	lsp-pyls-plugins-flake8-enabled t)
  :hook (
	 (python-mode . lsp)
         (go-mode . lsp)
	 ((c-mode c++-mode c-or-c++-mode) . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;;; Treat headers as C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;; Ivy

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy-rich
  :diminish
  :init
  (ivy-rich-mode 1))

;; White Space ===================================================

(use-package whitespace
  :init
  (setq whitespace-style (quote (face spaces tabs space-mark tab-mark)))
  (custom-set-faces
   '(whitespace-space ((t (:background nil :foreground "grey30")))))
  :hook (prog-mode . whitespace-mode))

;; Projectile ====================================================
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
 ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; Git ==========================================================

(use-package magit)

;; Python ========================================================

(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config (setq elpy-test-pytest-runner-command '("py.test" "--variant" "VARIANT_ION7400"))
  )

(put 'dired-find-alternate-file 'disabled nil)

(use-package company
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-roam magit which-key use-package rainbow-delimiters magit-section ivy-rich go-mode git-commit flycheck elpy doom-themes counsel-projectile))
 '(tramp-default-method "ssh"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-space ((t (:background nil :foreground "grey30")))))
(put 'upcase-region 'disabled nil)
