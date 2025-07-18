;;; auth-source-gopass.el --- Gopass integration for auth-source -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Markus M. May; 2025 Jens Neuhalfen
;; SPDX-License-Identifier: GPL-3.0-or-later

;; Author: Jens Neuhalfen <jens@neuhalfen.name> [0.0.4]
;;         Markus M. May <mmay@javafreedom.org> [till 0.0.3]
;; Created: 31 December 2022
;; URL: https://github.com/

;; Package-Requires: ((emacs "29.1"))

;; Version: 0.0.4

;;; Commentary:
;; This package adds gopass support to auth-source by calling
;; gopass from the command line.
;; This is in large parts copied from the
;; auth-source-kwallet.el and auth-source-pass.el packages.

;;; Code:
(require 'auth-source)

(defgroup auth-source-gopass nil
  "Gopass auth source settings."
  :group 'external
  :tag "auth-source-gopass"
  :prefix "gopass-")

(defcustom auth-source-gopass-path-prefix "accounts"
  "Prefix of the entries in the gopass backend."
  :type 'string
  :group 'auth-source-gopass)

(defcustom auth-source-gopass-path-separator "/"
  "Separator of elements in the gopass backend structure."
  :type 'string
  :group 'auth-source-gopass)

(defcustom auth-source-gopass-executable "gopass"
  "Executable used for gopass."
  :type 'string
  :group 'auth-source-gopass)


(defun  auth-source-gopass--find-candidates  (host user)
  "Run `gopass find' to find a list of candidate paths for the query HOST USER."
  (if (executable-find auth-source-gopass-executable)
      (let ((buf (get-buffer-create "*gopass*" t)))
        (with-current-buffer buf
          (erase-buffer)
          (let* ((regex (format "%s.*%s.*%s.*%s"
                                (or auth-source-gopass-path-prefix "")
                                (or host "")
                                auth-source-gopass-path-separator
                                (or user "")))
                 (gopass-exit-status (call-process auth-source-gopass-executable
                                                   nil
                                                   (current-buffer)
                                                   nil
                                                   "find" "--regex" regex)))
            (auth-source-do-trivia "auth-source-gopass: %s exit status: for finding host '%s' and user '%s' [rx: %s]: %d"
                                   auth-source-gopass-executable host user regex gopass-exit-status)

            (if  (not (= 0 gopass-exit-status))
                nil ;; keep the buffer content for diagnosis
              (let ((paths '()))
                (goto-char (point-min))
                (while (not (eobp))
                  (push (buffer-substring-no-properties (pos-bol) (pos-eol)) paths)
                  (line-move-1 1 t))

                (erase-buffer)
                (reverse paths))))))
    ;; If not executable was found, return nil and show a warning
    (warn "`auth-source-gopass': Could not find executable '%s' to query gopass" auth-source-gopass-executable)
    nil))

(defun auth-source-gopass--parse-gopass-secret (secret user)
  "Parse the gopass SECRET and return
- nil in case of error
- plist with :user and :secret

SECRET is a buffer.
The value for user will be parsed from the SECRET, if possible. Fallback is USER."
  (with-current-buffer secret
    (goto-char (point-min))
    (let (password
          username)
      (setq password (buffer-substring-no-properties (pos-bol) (pos-eol)))
      (line-move-1 1 t)
      (if (re-search-forward (rx line-start
                                 "username:" (one-or-more blank)
                                 (group (one-or-more not-newline)))
                             nil t)
          (setq username (match-string 1)))
      (if  (or (null password) (string= "" password))
          nil
        `(:user ,(or username user)
          :secret ,password)))))

(defun auth-source-gopass--get-user-from-path (path)
  "Get the user from PATH.
 a/b/c -> c and a/b/ -> nil.-"
  (let ((match (string-match (rx-to-string `(: ,auth-source-gopass-path-separator
                                             (group (one-or-more (not ,auth-source-gopass-path-separator)))
                                             eol))
                             path)))
    (if match
        (substring path (+ 1 match))
      nil)))

(defun auth-source-gopass--get-secret (path user)
  "Read the secret from PATH and construct the plist.
The user is in that precedence
- taken from the secret  (username: ...)
- taken from the path (bla/bla/username)
- taken from the USER parameter"

  (if (executable-find auth-source-gopass-executable)
      (let ((buf (get-buffer-create "*gopass*" t)))
        (with-current-buffer buf
          (erase-buffer)
          (let* ((gopass-exit-status (call-process auth-source-gopass-executable
                                                   nil
                                                   (current-buffer)
                                                   nil
                                                   "show" "--nosync" path)))
            (auth-source-do-trivia "auth-source-gopass: %s exit status: for query '%s': %d"
                                   auth-source-gopass-executable path gopass-exit-status)

            (if  (not (= 0 gopass-exit-status))
                nil ;; keep the buffer content for diagnosis
              (let* ((user (or  (auth-source-gopass--get-user-from-path path)
                                user))
                     (secret (auth-source-gopass--parse-gopass-secret buf user)))
                (erase-buffer)
                secret)))))
    ;; If not executable was found, return nil and show a warning
    (warn "`auth-source-gopass': Could not find executable '%s' to query gopass" auth-source-gopass-executable)
    nil))


(cl-defun auth-source-gopass-search (&rest spec
                                           &key backend type host user port
                                           &allow-other-keys)
  "Search gopass for the specified user and host.
SPEC, BACKEND, TYPE, HOST, USER and PORT are required by auth-source."
  (let* ((paths  (auth-source-gopass--find-candidates host user))
         (secrets (mapcar (lambda (path)
                            (auth-source-gopass--get-secret path user))
                          paths)))
    secrets))

;;;###autoload
(defun auth-source-gopass-enable ()
  "Enable the gopass auth source."
  (add-to-list 'auth-sources 'gopass)
  (auth-source-forget-all-cached))

(defvar auth-source-gopass-backend
  (auth-source-backend
   :source "."
   :type 'gopass
   :search-function #'auth-source-gopass-search))

(defun auth-source-gopass-backend-parse (entry)
  "Create a gopass auth-source backend from ENTRY."
  (when (eq entry 'gopass)
    (auth-source-backend-parse-parameters entry auth-source-gopass-backend)))

(if (boundp 'auth-source-backend-parser-functions)
    (add-hook 'auth-source-backend-parser-functions #'auth-source-gopass-backend-parse)
  (advice-add 'auth-source-backend-parse :before-until #'auth-source-gopass-backend-parse))

(provide 'auth-source-gopass)
;;; auth-source-gopass.el ends here
