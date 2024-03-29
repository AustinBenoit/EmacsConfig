;;; init.el

;; My configuration file.
;; Basic Idea is to have each major area have its own file and them
;; I will add them as needed.

(setq gc-cons-threshold 100000000)

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
  (setq font-size 150)
  (setq mac-command-modifier 'meta)))

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :config
  (setq exec-path-from-shell-variables '("PATH" "GOPATH"))
  (exec-path-from-shell-initialize))



(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)
(global-display-fill-column-indicator-mode t)


;;; The modules that control my config

(add-to-list 'load-path (expand-file-name "modules/" user-emacs-directory))

(require 'themes)

(require 'org_setup)


;;; General set ups

;; Remove the echo from CMD
;; (defun my-comint-init ()
;;  (setq comint-process-echoes t))
;;(add-hook 'comint-mode-hook 'my-comint-init)

(use-package dockerfile-mode)

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

;;; ORG Mode


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

(use-package go-mode
  :ensure t)

(use-package groovy-mode)

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l"
  lsp-pyls-plugins-flake8-enabled t)
  :hook (
  (python-mode . lsp)
  (go-mode . lsp)
  ((c-mode c++-mode c-or-c++-mode) . lsp)
  (javascript-mode . lsp)
  (typescript-mode . lsp)
  (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;;; Treat headers as C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))


(use-package typescript-mode
  :ensure t
  )


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
  (ivy-mode 1)
  (setq ivy-use-selectable-prompt t))

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

(put 'dired-find-alternate-file 'disabled nil)

(use-package company
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

(use-package yaml-mode
  :ensure t)

(add-to-list 'auto-mode-alist '("\\.yml\\'". yaml-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-roam magit which-key use-package rainbow-delimiters magit-section ivy-rich go-mode git-commit flycheck elpy doom-themes counsel-projectile))
 '(tramp-default-method "ssh" t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:inherit default :weight bold :foreground "#d4d4d4" :height 1.5))))
 '(org-level-2 ((t (:inherit default :weight bold :foreground "#d4d4d4" :height 1.25))))
 '(org-level-3 ((t (:inherit default :weight bold :foreground "#d4d4d4" :height 1.1))))
 '(org-level-4 ((t (:inherit default :weight bold :foreground "#d4d4d4"))))
 '(org-level-5 ((t (:inherit default :weight bold :foreground "#d4d4d4"))))
 '(org-level-6 ((t (:inherit default :weight bold :foreground "#d4d4d4"))))
 '(org-level-7 ((t (:inherit default :weight bold :foreground "#d4d4d4"))))
 '(org-level-8 ((t (:inherit default :weight bold :foreground "#d4d4d4"))))
 '(whitespace-space ((t (:background nil :foreground "grey30")))))
(put 'upcase-region 'disabled nil)
