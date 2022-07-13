;;; org_setup.el -*- lexical-binding: t; -*-

;; Commentary

;; Emacs theme configuration.

;;; Code:
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
    (setq org-log-done t)
    (setq org-agenda-files (directory-files-recursively "~/Notes/" "\\.org$")))

  (use-package org-bullets
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-roam-ui
  :after org-roam
  ;;normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;a hookable mode anymore, you're advised to pick something yourself
  ;;if you don't care about startup time, use
  :hook (after-init . org-roam-ui-mode)
  :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start nil
          org-hide-emphasis-markers t)
    :bind(("C-c n u"   . org-roam-ui-mode)))
 (let* ((variable-tuple
          (cond ((x-list-fonts "Ariel")         '(:font "Ariel"))
                ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
                (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
         (base-font-color     (face-foreground 'default nil 'default))
         (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

    (custom-theme-set-faces
     'user
     `(org-level-8 ((t (,@headline ,@variable-tuple))))
     `(org-level-7 ((t (,@headline ,@variable-tuple))))
     `(org-level-6 ((t (,@headline ,@variable-tuple))))
     `(org-level-5 ((t (,@headline ,@variable-tuple))))
     `(org-level-4 ((t (,@headline ,@variable-tuple))))
     `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.1))))
     `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.25))))
     `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.5))))))

(provide 'org_setup)
;;; themes.el ends here
