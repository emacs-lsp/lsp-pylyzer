;;; lsp-pylyzer.el --- Python LSP client using pylyzer -*- lexical-binding: t; -*-

;; Copyright (C) 2024 emacs-lsp maintainers

;; Author: Vincent Zhang
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (lsp-mode "7.0") (dash "2.18.0") (ht "2.0"))
;; Homepage: https://github.com/seagle0128/lsp-pylyzer
;; Keywords: languages, tools, lsp


;; This file is not part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <https://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;;  pylyzer language server.
;;
;;; Code:

(require 'lsp-mode)
(require 'dash)
(require 'ht)

;; Group declaration
(defgroup lsp-pylyzer nil
  "LSP support for python using the pylyzer Language Server."
  :group 'lsp-mode
  :link '(url-link "https://github.com/mtshiba/pylyzer"))

(defcustom lsp-pylyzer-langserver-command-args '("--server")
  "Command to start pylyzer language server."
  :type '(repeat string)
  :group 'lsp-pylyzer)

(defcustom lsp-pylyzer-multi-root t
  "If non nil, lsp-pylyzer will be started in multi-root mode."
  :type 'boolean
  :group 'lsp-pylyzer)

(defcustom lsp-pylyzer-python-executable-cmd "python"
  "Command to specify the Python command for pylyzer.
Similar to the `python-shell-interpreter', but used only with mspyls.
Useful when there are multiple python versions in system.
e.g, there are `python2' and `python3', both in system PATH,
and the default `python' links to python2,
set as `python3' to let ms-pyls use python 3 environments."
  :type 'string
  :group 'lsp-pylyzer)

(defun lsp-pylyzer--begin-progress-callback (workspace &rest _)
  "Log begin progress information.
Current LSP WORKSPACE should be passed in."
  (when lsp-progress-via-spinner
    (with-lsp-workspace workspace
                        (--each (lsp--workspace-buffers workspace)
                          (when (buffer-live-p it)
                            (with-current-buffer it
                              (lsp--spinner-start))))))
  (lsp-log "pylyzer language server is analyzing..."))

(defun lsp-pylyzer--report-progress-callback (_workspace params)
  "Log report progress information.
First element of PARAMS will be passed into `lsp-log'."
  (when (and (arrayp params) (> (length params) 0))
    (lsp-log (aref params 0))))

(defun lsp-pylyzer--end-progress-callback (workspace &rest _)
  "Log end progress information.
Current LSP WORKSPACE should be passed in."
  (when lsp-progress-via-spinner
    (with-lsp-workspace workspace
      (--each (lsp--workspace-buffers workspace)
        (when (buffer-live-p it)
          (with-current-buffer it
            (lsp--spinner-stop))))))
  (lsp-log "pylyzer language server is analyzing...done"))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection (lambda ()
                                          (cons (executable-find "pylyzer" t)
                                                lsp-pylyzer-langserver-command-args)))
  :major-modes '(python-mode python-ts-mode)
  :server-id 'pylyzer
  :multi-root lsp-pylyzer-multi-root
  :priority 4
  :initialized-fn (lambda (workspace)
                    (with-lsp-workspace workspace
                      ;; we send empty settings initially, LSP server will ask for the
                      ;; configuration of each workspace folder later separately
                      (lsp--set-configuration
                       (make-hash-table :test 'equal))))
  :download-server-fn (lambda (_client callback error-callback _update?)
                        (lsp-package-ensure 'pylyzer callback error-callback))
  :notification-handlers (lsp-ht ("pylyzer/beginProgress" 'lsp-pylyzer--begin-progress-callback)
                                 ("pylyzer/reportProgress" 'lsp-pylyzer--report-progress-callback)
                                 ("pylyzer/endProgress" 'lsp-pylyzer--end-progress-callback))))

(lsp-register-client
 (make-lsp-client
  :new-connection
  (lsp-tramp-connection (lambda ()
                          (cons (executable-find "pylyzer" t)
                                lsp-pylyzer-langserver-command-args)))
  :major-modes '(python-mode python-ts-mode)
  :server-id 'pylyzer-remote
  :multi-root lsp-pylyzer-multi-root
  :remote? t
  :priority 3
  :initialized-fn (lambda (workspace)
                    (with-lsp-workspace workspace
                      ;; we send empty settings initially, LSP server will ask for the
                      ;; configuration of each workspace folder later separately
                      (lsp--set-configuration
                       (make-hash-table :test 'equal))))
  :notification-handlers (lsp-ht ("pylyzer/beginProgress" 'lsp-pylyzer--begin-progress-callback)
                                 ("pylyzer/reportProgress" 'lsp-pylyzer--report-progress-callback)
                                 ("pylyzer/endProgress" 'lsp-pylyzer--end-progress-callback))))

(provide 'lsp-pylyzer)
;;; lsp-pylyzer.el ends here
