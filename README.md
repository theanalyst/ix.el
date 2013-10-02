README
======

`ix.el` is a simple emacs client to http://ix.io cmdline pastebin.

** Installation

To install, copy `ix.el` to somewhere your emacs can find, on your
load path. Usually something like:

    $ mkdir ~/.emacs.d/ix
    $ cp ix.el ~/.emacs.d/ix.el

To the `user-init-file` (.emacs) add the following:

    (add-to-list 'load-path "~/.emacs.d/ix")
    (require 'ix)

`ix` also requires a curl to be in your exec-path.

** Usage

At the moment executing `M-x ix` command on a selection sends the
selection to ix.io, entire buffer is sent if selection is inactive, on
success the url is notified in the minibuffer as well as saved in the
kill ring.

It is recommended to set a user-name and token so that your pastes can
be deleted/replaced at a later time. These can be set by


    M-x customize-group RET ix

and setting the values for the variable `ix-user` and `ix-token`. If
the user name didn't exist previously it is created during the first
time `ix` is used.

** More info

`ix` was built a top of (grapnel)[https://github.com/leathekd/grapnel]
http request library.

Please report issues, improvements etc. at ix github page
