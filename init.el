; ================================================================
;; Basic Set ups
;; ===============================================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (wheatgrass)))
 '(elpy-test-pytest-runner-command (quote ("py.test" "--variant" "VARIANT_ION7400")))
 '(flycheck-python-flake8-executable
   "C:\\Users\\sesa638306\\AppData\\Local\\Programs\\Python\\Python37\\Scripts\\flake8.exe")
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (ivy use-package go-mode flycheck elpy)))
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-space ((t (:background nil :foreground "grey30")))))

;; General set ups ==============================================
(tool-bar-mode -1)
(setq visible-bell t)

(set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 120)

;; (setq default-directory "c:/")   Home is fine on linux
(global-linum-mode t)               ;; Enable line numbers globally

;; Remove the echo from CMD
;;(defun my-comint-init ()
;;  (setq comint-process-echoes t))
;;(add-hook 'comint-mode-hook 'my-comint-init)

;; spell checking for text and programing
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

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
(use-package flycheck)
(global-flycheck-mode)

(use-package swiper)

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

;; White Space ===================================================
(require 'whitespace)

(setq whitespace-style (quote (face spaces tabs space-mark tab-mark)))

(add-hook 'prog-mode-hook 'whitespace-mode)

;; Python ========================================================
(use-package elpy)
(elpy-enable)
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(put 'dired-find-alternate-file 'disabled nil)
