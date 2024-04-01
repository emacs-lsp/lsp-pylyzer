# lsp-pylyzer

[![Build Status](https://github.com/emacs-lsp/lsp-pylyzer/workflows/CI/badge.svg?branch=master)](https://github.com/emacs-lsp/lsp-pylyzer/actions)
[![License](http://img.shields.io/:License-GPL3-blue.svg)](License)
[![MELPA](https://melpa.org/packages/lsp-pylyzer-badge.svg)](https://melpa.org/#/lsp-pylyzer)
[![Join the chat at https://gitter.im/emacs-lsp/lsp-mode](https://badges.gitter.im/emacs-lsp/lsp-mode.svg)](https://gitter.im/emacs-lsp/lsp-mode?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->

## Table of Contents

- [Quickstart](#quickstart)
- [FAQ](#faq)

<!-- markdown-toc end -->

lsp-mode client leveraging [Pylyzer language server](https://github.com/mtshiba/pylyzer)

## Quickstart

```emacs-lisp
(use-package lsp-pylyzer
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pylyzer)
                          (lsp))))  ; or lsp-deferred
```

## FAQ
