(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(when (eq system-type 'windows-nt)
  (setq package-check-signature nil))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(setq display-line-numbers-type 'absolute)
(global-display-line-numbers-mode 1)
(when (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :font "Liberation Mono-12"))
(setq visible-bell t)
(ido-mode 1)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t
      ido-everywhere t)
(cua-mode 1)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(global-set-key (kbd "C-1") #'windmove-left)
(global-set-key (kbd "C-2") #'windmove-right)

(add-hook
 'window-setup-hook
 (lambda ()
   (delete-other-windows)
   (switch-to-buffer "*scratch*")
   (let ((right (split-window-right)))
     (when-let ((splash (get-buffer "*GNU Emacs*")))
       (set-window-buffer right splash)))))

(add-hook 'c-mode-common-hook
          (lambda ()
            (setq c-basic-offset 4)
            (setq-local indent-tabs-mode nil)
            (c-set-offset 'substatement-open 0)
            (c-set-offset 'case-label '+)
            (c-set-offset 'statement-case-intro '+)
            (c-set-offset 'statement-case-open 0)))

(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(defun occur-symbol-at-point ()
  (interactive)
  (occur (thing-at-point 'symbol t)))

(when (eq system-type 'windows-nt)
  (defun project/find-root ()
    "Walk up from current buffer's directory until Build.bat is found."
    (let ((dir (expand-file-name
                (or (and buffer-file-name
                         (file-name-directory buffer-file-name))
                    default-directory))))
      (locate-dominating-file dir "Build.bat")))
  
  (defun project/build (&optional mode)
    "Build the project. MODE is \"release\" or nil/omitted for debug."
    (interactive)
    (let ((root (project/find-root)))
      (if (not root)
          (user-error "[Build] Could not find Build.bat from %s" default-directory)
        (let* ((root (expand-file-name root))
               (mode (or mode "debug"))
               (cmd  (format "cmd.exe /c \"cd /d %s && Build.bat %s\""
                             (shell-quote-argument root) mode))
               (compilation-buffer-name-function (lambda (_) "*Build*")))
          (compile cmd)))))
  
  (defun project/run (&optional mode)
    "Run the project. MODE is \"release\" or nil/omitted for debug."
    (interactive)
    (let ((root (project/find-root)))
      (if (not root)
          (user-error "[Run] Could not find Run.bat from %s" default-directory)
        (let* ((root (expand-file-name root))
               (mode (or mode "debug"))
               (cmd  (format "cmd.exe /c \"cd /d %s && Run.bat %s\""
                             (shell-quote-argument root) mode)))
          (async-shell-command cmd "*Run*"))))))

(global-set-key (kbd "M-<down>") 'move-line-down)
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "C-s") #'occur-symbol-at-point)
(global-set-key (kbd "C-f") #'isearch-forward)

(when (eq system-type 'windows-nt)
  (global-set-key (kbd "C-b") #'project/build)
  (global-set-key (kbd "C-S-b") (lambda () (interactive) (project/build "release")))
  (global-set-key (kbd "C-r") #'project/run)
  (global-set-key (kbd "C-S-r") (lambda () (interactive) (project/run "release"))))
