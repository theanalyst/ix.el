;;; ix.el --- Emacs client for http://ix.io pastebin

;; Copyright © 2013  Abhishek L

;; Author: Abhishek L <abhishekl.2006@gmail.com>
;; URL: http://www.github.com/theanalyst/ix.el
;; Version: 0.6.1
;; Package-Requires: ((grapnel "0.5.3"))

;; This file is not part of GNU Emacs.

;;; Commentary:

;; ix.el is a simple emacs client to http://ix.io cmdline pastebin. At
;; the moment using the `ix' command on a selection sends the
;; selection to ix.io, entire buffer is sent if selection is inactive,
;; on success the url is notified in the minibuffer as well as saved
;; in the kill ring.
;;
;; It is recommended to set a user name and token so that you can
;; later delete or replace a paste. Set this via the variables
;; `ix-user' and `ix-token' via M-x customize-group RET ix
;;
;; Posts (if posted with user and token) can be deleted by `ix-delete'
;; command which prompts for post id (the string after http://ix.io/)
;;
;; curl is used as the backend via grapnel http request library.
;;

;; History

;; 0.5 - Initial release.
;; 0.6 - Added delete posts functionality
;; 0.6.1 - Minor fix for `ix-delete' interactive form
;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:
(require 'grapnel)

(defgroup ix nil
  "ix -- the Emacs http://ix.io pastebin client"
  :tag "ix"
  :group 'applications)

(defcustom ix-user nil
  "user name for posting at http://ix.io"
  :type 'string
  :group 'ix)

(defcustom ix-token nil
  "token/password for posting at http://ix.io"
  :type 'string
  :group 'ix)

(defun ix-post (text)
  (grapnel-retrieve-url "http://ix.io"
                        `((success . ix-post--success-callback)
                          (failure . (lambda (res hdrs) (message "failure! %s" hdrs)))
                          (error . (lambda (res err) (message "err %s" err))))
                        "POST"
                        nil
                        `((,(format "%s:%s" "f" (length text)) . ,text)
                          ("login" . ,ix-user)
                          ("token" . ,ix-token))))

(defun ix-post--success-callback (res hdrs)
  (let ((ix-url (substring res 0 -1))) ;; removing newline
    (message "Paste created and saved to kill-ring url: %s" ix-url)
    (kill-new ix-url)))

;;;###autoload
(defun ix-delete (ix-url)
  "Delete a post, this requires you to be logged in. Only the
  post id needs to be specified"
  (interactive "sEnter ix url to delete:")
  (grapnel-retrieve-url "http://ix.io"
                        `((success . (lambda (res hdrs) (message "%s"
                                                            (substring res 0 -1))))
                           (failure . (lambda (res hdrs) (message "failure! %s" hdrs)))
                           (error . (lambda (res err) (message "err %s" err))))
                         "POST"
                         nil
                         `((,(format "%s:%s" "f" (length ix-url)) . "")
                           ("login" . ,ix-user)
                           ("token" . ,ix-token)
                           ("rm" . ,ix-url))))

;;;###autoload
(defun ix (start end)
  "Paste the region at http://ix.io, url returned is saved to the
   kill ring. It is recommended to set up a username and token by
   configuring the variables `ix-user' and `ix-token'"
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (point-min) (point-max))))
  (let ((selection (buffer-substring-no-properties start end)))
    (message "posting...")
    (ix-post selection)))

(provide 'ix)

;;; ix.el ends here
