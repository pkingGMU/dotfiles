(setq custom-file "~/.emacs.custom.el")
(add-to-list 'load-path "~/.emacs.d/auto-complete-lua/")
(add-to-list 'load-path "~/lua-language-server/")


(load-file custom-file)
(load-theme 'gruber-darker t)


;; Default Dir
(setq default-directory "/mnt/code/code/git/")

;; Keybinds


;;resizing windows
(global-set-key (kbd "S-C-<left>")  'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>")  'shrink-window)
(global-set-key (kbd "S-C-<up>")    'enlarge-window)


(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(global-font-lock-mode t)
(global-auto-revert-mode 1)

(ido-mode 1)
(ido-everywhere 1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
(set-face-attribute 'tab-bar-tab-inactive nil :background 'unspecified)

;; I Don't care about snippets
(setq lsp-enable-snippet nil)


(unless (package-installed-p 'company)
  (package-refresh-contents)
  (package-install 'company))

(require 'company)

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)


(package-initialize)



(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Vertico
(use-package vertico
  :init
  (vertico-mode))

;; Orderless
(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Consult
(use-package consult
  :bind
  (("C-s" . consult-line)
   ("C-x b" . consult-buffer)
   ("M-y" . consult-yank-pop)
   ("C-x C-r" . consult-recent-file)))

;; Embark
(use-package embark
  :bind
  (("C-." . embark-act)         ;; act on thing at point
   ("C-;" . embark-dwim)        ;; smart default action
   ("C-h B" . embark-bindings)) ;; show available keybindings
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

;; Embark-Consult Integration
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))


;; Stop annoying ringing
(setq ring-bell-function 'ignore)
(setq inhibit-startup-screen t)

;; MATLAB Path
(setq matlab-shell-command "/usr/local/MATLAB/R2024b/bin/matlab"
      matlab-shell-command-switches '("-nodesktop" "-nosplash"))

(use-package matlab-mode
  :ensure t
  :mode ("\\.m\\'" . matlab-mode)
  :config
  (setq matlab-shell-command "/usr/local/MATLAB/R2024b/bin/matlab"))


;; Indentation and Autocomplete
(setq matlab-indent-function t)
(add-hook 'matlab-mode-hook 'company-mode)
(add-hook 'matlab-mode-hook 'eldoc-mode)

;; Company settings
(with-eval-after-load 'company
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2
        company-tooltip-align-annotation t))

;; React Stuff

(use-package rjsx-mode
  :ensure t
  :mode ("\\.jsx\\'" . rjsx-mode)
  :mode ("\\.tsx\\'" . rjsx-mode))

(use-package emmet-mode
  :ensure t
  :hook ((html-mode . emmet-mode)
         (rjsx-mode . emmet-mode)))

(global-set-key (kbd "C-c r") 'react-run-server)
(global-set-key (kbd "C-c b") 'react-build)

;; Install useful packages
(use-package rjsx-mode
  :ensure t
  :mode ("\\.jsx\\'" . rjsx-mode)
  :mode ("\\.tsx\\'" . rjsx-mode))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package prettier
  :ensure t
  :hook ((js2-mode typescript-mode) . prettier-mode)
  :config
  (setq prettier-js-args '("--single-quote" "--trailing-comma" "es5")))

(use-package emmet-mode
  :ensure t
  :hook ((html-mode . emmet-mode)
         (rjsx-mode . emmet-mode)))

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))

(use-package lsp-mode
  :ensure t
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-tailwindcss
  :ensure t
  :after lsp-mode)


;; Dap Debug

(require 'dap-mode)

;; 1. Register an adapter for Love2D
(dap-register-debug-provider "love"
  (lambda (conf) conf))

(dap-register-debug-template "Love2D Run Project"
  (list :type "love"  ;; <- must match adapter name
        :request "launch"
        :name "Launch Love2D"
        :program "love"
        :args (vector ".")
        :cwd (expand-file-name ".")
        :console "integratedTerminal"))

(use-package lua-mode
  :ensure t)

;; Lua Stuff



;; Supress
(setq native-comp-async-report-warnings-errors nil)
(require 'auto-complete-lua)(add-hook 'lua-mode-hook
				      '(lambda () (setq ac-sources'(ac-source-lua)) (auto-complete-mode 1)))


;; 3.1 Lua major mode
;; Lua-specific settings
(use-package lua-mode
  :mode "\\.lua\\'"
  :interpreter "lua"
  :hook ((lua-mode . lsp-deferred)
         (lua-mode . (lambda ()
                       ;; Ensure font-lock is enabled for Lua
                       (font-lock-mode t)
                       (setq indent-tabs-mode nil
                             lua-indent-level 2)
                       (setq display-line-numbers 'relative)
                       (display-line-numbers-mode t)))))

  :config


(global-font-lock-mode 1)


;; LSP Config
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (lua-mode . lsp-deferred)
  ;;:contentReference[oaicite:3]{index=3}
  :init
    (setq lsp-keymap-prefix "C-c l")    ; prefix for LSP commands
  ;; Point to your freshly built server:
  (setq lsp-clients-lua-language-server-bin
        (expand-file-name "~/lua-language-server/bin/lua-language-server"))
  (setq lsp-clients-lua-language-server-main-location
        (expand-file-name "~/lua-language-server/bin/main.lua")))  ; built‑in client config :contentReference[oaicite:4]{index=4}


;; 3.3 Completion framework
(use-package company
  :ensure t
  :hook (lsp-mode . company-mode)
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 1))  ; lsp-mode ↔ company integration :contentReference[oaicite:5]{index=5}

;; 3.4 UI polish: sideline diagnostics, docs popups
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :init
  (setq lsp-ui-sideline-enable t
        lsp-ui-doc-enable t))  ; fancy sideline, hover docs, peek UI :contentReference[oaicite:6]{index=6}
"For icon-enriched completion":
(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

(use-package all-the-icons :ensure t)
;; After installing these, run M-x all-the-icons-install-fonts 
	 

;; Start Fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Open Side by Side :3
(add-hook 'emacs-startup-hook
      (lambda ()
        (split-window-right)))

;; Force enabling font-lock mode globally after theme is applied
(add-hook 'emacs-startup-hook
          (lambda ()
            (global-font-lock-mode t)))






;; C# Development ;;;;;;;;

;; Eglot
(setq eglot-report-progress nil)
