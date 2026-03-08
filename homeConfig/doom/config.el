;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jose Maldonado"
       user-mail-address "yukiteruamano@volfread.xyz")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "Fira Mono" :size 11 :weight 'regular)
    doom-variable-pitch-font (font-spec :family "Fira Mono" :size 12))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; =========================================================================
;; Flycheck config
;; =========================================================================

(after! flycheck
  ;; Flycheck for Clang
  (setq-default flycheck-c/c++-clang-executable "/usr/local/bin/clang-21")
)

;; =========================================================================
;; Flyspell config
;; =========================================================================

;; Grammar
;; Flyspell 
(after! flyspell
  (setq ispell-program-name "aspell")
  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))
  (setq flyspell-lazy-idle-seconds 5))

;; =========================================================================
;; Styling
;; =========================================================================
(setq indent-tabs-mode t)
(setq tab-width 4)

;; =========================================================================
;; Clangd styling code
;; =========================================================================

;; Styling code
;; BSD Style
(add-hook! (c-mode c++-mode)
  (setq c-default-style "bsd")
  (setq c-basic-offset 4))

;; BSD Style for OpenBSD
(defun bsd-style-code () (interactive)
  (c-set-style "bsd")
    (setq indent-tabs-mode t)
      ;; Use C-c C-s at points of source code so see which
      ;; c-set-offset is in effect for this situation
      (c-set-offset 'defun-block-intro 8)
      (c-set-offset 'statement-block-intro 8)
      (c-set-offset 'statement-case-intro 8)
      (c-set-offset 'substatement-open 4)
      (c-set-offset 'substatement 8)
      (c-set-offset 'arglist-cont-nonempty 4)
      (c-set-offset 'inclass 8)
      (c-set-offset 'knr-argdecl-intro 8))

(with-eval-after-load 'cc-mode
  (set-eglot-client! 'cc-mode '("clangd" 
				"-j=4"
				"--background-index"
				"-clang-tidy"
				"--all-scopes-completion"
				"--completion-style=detailed"
				"--header-insertion=iwyu"
				"--header-insertion-decorators=0"
				)))

;; =========================================================================
;; Python
;; =========================================================================

;; Python3 configuration
(setq python-shell-interpreter "/usr/local/bin/python3")
(setq flycheck-python-pycompile-executable "/usr/local/bin/python3")
(setq python-shell-exec-path "/usr/local/bin/python3")

;; Config for ipython and jupyter
(setq +python-ipython-repl-args '("-i" "--simple-prompt" "--no-color-info"))
(setq +python-jupyter-repl-args '("--simple-prompt"))

;; DAP mode for python
(after! dap-mode
  (setq dap-python-debugger 'debugpy))

;; Ty LSP
(with-eval-after-load 'python
  (set-eglot-client! '(python-mode python-ts-mode) '("ty" "server")))

(with-eval-after-load 'python
  (set-lsp-priority! 'ty-ls -5))

(with-eval-after-load 'python
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode)))

;; =========================================================================
;; Magit config
;; =========================================================================

;; Gravatar support for magit-commits
(after! magit
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")))

;; =========================================================================
;; Performance config
;; =========================================================================

;; Garbage collector
(after! gcmh
  (setq gcmh-high-cons-threshold 268435456)
  (setq gc-cons-threshold 268435456))

;; Better lsp performance
(setq read-process-output-max (* 1024 1024))


;; =========================================================================
;; GUI config
;; =========================================================================

;; Maximus 80 columns of text
(add-hook 'prog-mode-hook (lambda ()
	(setq fill-column 80)
	(setq display-fill-column-indicator t)
	(setq display-fill-column-indicator-column t)
	;; (display-fill-column-indicator-mode)
	(global-display-fill-column-indicator-mode)))

;; THEMES
;; Catpuccin
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha)

;; UI Tweaks
;; Splash screen personalized
(defun new-banner-happy ()
  (let* ((banner '("⢸⣿⣿⣿⣿⠃⠄⢀⣴⡾⠃⠄⠄⠄⠄⠄⠈⠺⠟⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣶⣤⡀⠄"
                   "⢸⣿⣿⣿⡟⢀⣴⣿⡿⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⣿⣷"
                   "⢸⣿⣿⠟⣴⣿⡿⡟⡼⢹⣷⢲⡶⣖⣾⣶⢄⠄⠄⠄⠄⠄⢀⣼⣿⢿⣿⣿⣿⣿⣿⣿⣿"
                   "⢸⣿⢫⣾⣿⡟⣾⡸⢠⡿⢳⡿⠍⣼⣿⢏⣿⣷⢄⡀⠄⢠⣾⢻⣿⣸⣿⣿⣿⣿⣿⣿⣿"
                   "⡿⣡⣿⣿⡟⡼⡁⠁⣰⠂⡾⠉⢨⣿⠃⣿⡿⠍⣾⣟⢤⣿⢇⣿⢇⣿⣿⢿⣿⣿⣿⣿⣿"
                   "⣱⣿⣿⡟⡐⣰⣧⡷⣿⣴⣧⣤⣼⣯⢸⡿⠁⣰⠟⢀⣼⠏⣲⠏⢸⣿⡟⣿⣿⣿⣿⣿⣿"
                   "⣿⣿⡟⠁⠄⠟⣁⠄⢡⣿⣿⣿⣿⣿⣿⣦⣼⢟⢀⡼⠃⡹⠃⡀⢸⡿⢸⣿⣿⣿⣿⣿⡟"
                   "⣿⣿⠃⠄⢀⣾⠋⠓⢰⣿⣿⣿⣿⣿⣿⠿⣿⣿⣾⣅⢔⣕⡇⡇⡼⢁⣿⣿⣿⣿⣿⣿⢣"
                   "⣿⡟⠄⠄⣾⣇⠷⣢⣿⣿⣿⣿⣿⣿⣿⣭⣀⡈⠙⢿⣿⣿⡇⡧⢁⣾⣿⣿⣿⣿⣿⢏⣾"
                   "⣿⡇⠄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢻⠇⠄⠄⢿⣿⡇⢡⣾⣿⣿⣿⣿⣿⣏⣼⣿"
                   "⣿⣷⢰⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⢰⣧⣀⡄⢀⠘⡿⣰⣿⣿⣿⣿⣿⣿⠟⣼⣿⣿"
                   "⢹⣿⢸⣿⣿⠟⠻⢿⣿⣿⣿⣿⣿⣿⣿⣶⣭⣉⣤⣿⢈⣼⣿⣿⣿⣿⣿⣿⠏⣾⣹⣿⣿"
                   "⢸⠇⡜⣿⡟⠄⠄⠄⠈⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟⣱⣻⣿⣿⣿⣿⣿⠟⠁⢳⠃⣿⣿⣿"
                   "⠄⣰⡗⠹⣿⣄⠄⠄⠄⢀⣿⣿⣿⣿⣿⣿⠟⣅⣥⣿⣿⣿⣿⠿⠋⠄⠄⣾⡌⢠⣿⡿⠃"
                   "⠜⠋⢠⣷⢻⣿⣿⣶⣾⣿⣿⣿⣿⠿⣛⣥⣾⣿⠿⠟⠛⠉⠄⠄          "))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat line (make-string (max 0 (- longest-line (length line))) 32)))
               "\n"))
     'face 'doom-dashboard-banner)))

;; Init new splash screen
(setq +doom-dashboard-ascii-banner-fn #'new-banner-happy)

;; Append new message in init dashboard 
(add-hook! '+doom-dashboard-functions :append
  (insert "\n" (+doom-dashboard--center +doom-dashboard--width "Powered by Emacs!")))
	(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)

;; Hook for rainbow-mode
(add-hook! 'rainbow-mode-hook
  (hl-line-mode (if rainbow-mode -1 +1)))

;; xterm mouse support
(setq xterm-mouse-mode 1)

;; Eglot
(after! eglot
  (setq eglot-watch-files-outside-project-root nil))


