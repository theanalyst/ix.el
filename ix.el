(require 'grapnel)
(require 'json)

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
                        `((success . (lambda (res hdrs) (message "url: %s" res) )) ;; TODO add this to kill-ring
                          (failure . (lambda (res hdrs) (message "failure! %s" hdrs)))
                          (error . (lambda (res err) (message "err %s" err))))
                        "POST"
                        nil
                        `((,(format "%s:%s" "f" (length text)) . ,text)
                          ("login" . ,ix-user)
                          ("token" . ,ix-token))))

(defun ix (start end)
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (point-min) (point-max))))
  (let ((selection (buffer-substring-no-properties start end)))
    (message "posting...")
    (ix-post selection)))

(provide 'ix)
