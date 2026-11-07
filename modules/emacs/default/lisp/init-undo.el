;;; init-undo.el --- undo & redo -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package undo-fu ; 普通undo & redo
  :bind
  ("C-z" . undo-fu-only-undo)
  ("C-S-z" . undo-fu-only-redo))

(use-package vundo ; 可视化历史树
  :bind ("C-M-z" . vundo))

(provide 'init-undo)
;;; init-undo.el ends here
