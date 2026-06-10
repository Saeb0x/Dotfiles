(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(when (eq system-type 'windows-nt)
  (setq package-check-signature nil))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(setq display-line-numbers-type 'absolute)
(global-display-line-numbers-mode 1)
(set-face-attribute 'default nil :font "Liberation Mono-12")
(setq visible-bell t)
(ido-mode 1)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t
      ido-everywhere t)
(cua-mode 1)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default standard-indent 4)

(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(global-set-key (kbd "M-<down>") 'move-line-down)
(global-set-key (kbd "M-<up>") 'move-line-up)