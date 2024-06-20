# lsp-pylyzer

[![CI](https://github.com/emacs-lsp/lsp-pylyzer/actions/workflows/test.yml/badge.svg)](https://github.com/emacs-lsp/lsp-pylyzer/actions/workflows/test.yml)
[![License](http://img.shields.io/:License-GPL3-blue.svg)](License)
[![JCS-ELPA](https://raw.githubusercontent.com/jcs-emacs/badges/master/elpa/v/lsp-pylyzer.svg)](https://jcs-emacs.github.io/jcs-elpa/#/lsp-pylyzer)
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
