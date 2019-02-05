;;; org-pretty-jump --- Perform actions on org mode headers using a pretty menu -*- lexical-binding: t -*-

;; Copyright (C) Me

;; Author: Me
;; Keywords: org, ivy, navigation, jump, refile
;; Version: 0.0.1
;; Package-Requires: ((emacs "26.1") (org "9.2"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Put a description of the package here

;;; Code:

;; requires
(require 'org)

;; code goes here
(defun opj/lib-get-candidates (&optional style components handle-files)
  (let (candidates)
    (org-map-entries
     (lambda ()
       (let* ((h (org-get-heading))
              (comp (org-heading-components))
              (level (nth 0 comp))
              (todo (nth 2 comp))
              (priority (nth 3 comp))
              (text (nth 4 comp))
              (tags (nth 5 comp)))
         (push
          (cons 
           (concat
            (if (member 'level components)
                (concat (format "%d" level) " ")
              "")
            (if (member 'indent components)
                (make-string (* 2 (1- level)) ?\ )
              "")
            (if (eq style t)
                (org-format-outline-path (org-get-outline-path t))
              h))
           (point-marker))
          candidates))))
    (nreverse candidates)))

;;;###autoload
(defun opj/get-heading-pos (&optional long-style components handle-files)
  (let ((cands (opj/lib-get-candidates long-style components handle-files)))
    (cdr (assoc (ivy-read "Heading: "
                          cands)
                cands))))
;;;###autoload
(defun opj/act-on-heading (action &optional long-style components handle-files)
  (ivy-read "Heading: "
            (opj/lib-get-candidates long-style components handle-files)
            :action (lambda (x) (apply action `(,(cdr x)))))
  nil)

(provide 'org-pretty-jump)
;;; test.el ends here

;; Local Variables:
;; nameless-current-name: "opj"
;; nameless-separator: "/"
;; End:
