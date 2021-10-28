;;================================================================

;; Basic Set ups

;; ===============================================================
(tool-bar-mode -1)
(setq visible-bell t)
(setq inhibit-startup-message t)
(set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 120)

;; (setq default-directory "c:/")   Home is fine on linux
(global-linum-mode t)               ;; Enable line numbers globally

;; ===============================================================
;; Packages
;; ===============================================================

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms

(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; General set ups ==============================================

;; Remove the echo from CMD
;;(defun my-comint-init ()
;;  (setq comint-process-echoes t))
;;(add-hook 'comint-mode-hook 'my-comint-init)

;; spell checking for text and programing

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 2))

(use-package doom-themes
  :init (load-theme 'doom-dark+ t))

;; ===============================================================
;; ORG MODE SET UPS
;; ===============================================================

(require 'org)

(define-key global-map "\C-cl" 'org-store-link)

(define-key global-map "\C-ca" 'org-agenda)

(setq org-todo-keywords
      '((sequence "TODO" "BLOCKED" "VERIFY" "|" "DONE" "DELEGATED")))

(setq org-log-done t)

;; ===============================================================
;; Set up Hunspell for spell checking
;; ===============================================================

(add-to-list 'exec-path "C:/hunspell/hunspell-1.3.2-3-w32-bin/bin")

(setq ispell-program-name (locate-file "hunspell"
    exec-path exec-suffixes 'file-executable-p))

(setq ispell-local-dictionary "en_US")

(setq ispell-local-dictionary-alist
      '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))


;; ===============================================================
;; Set Up Programming environment
;; ===============================================================

;; General =======================================================

(use-package flycheck
  :init (global-flycheck-mode 1)
  (setq flycheck-python-flake8-executable '("C:/Users/sesa638306/AppData/Local/Programs/Python/Python37/Scripts/flake8.exe")))

(use-package swiper)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(add-hook 'before-save-hook 'gofmt-before-save)

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         (go-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; Ivy ===========================================================

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
  :config '(elpy-test-pytest-runner-command '("py.test" "--variant" "VARIANT_ION7400"))
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
   '(magit which-key use-package rainbow-delimiters magit-section ivy-rich go-mode git-commit flycheck elpy doom-themes counsel-projectile)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-space ((t (:background nil :foreground "grey30")))))
