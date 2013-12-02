README
======

`ix.el` is a simple emacs client to http://ix.io cmdline pastebin.

Installation
------------


### via `package.el`

`ix.el` is available as a package via MELPA or Marmalade. If 
MELPA/Marmalade is already added to your package archives 
install the package `ix.el` from there. Otherwise 
do this in a `*scratch*` buffer:

    (require 'package)
    (add-to-list 'package-archives
             '("MELPA" . "http://melpa.milkbox.net/packages/" )
             '("marmalade" . "http://marmalade-repo.org/packages/"))
             
Then run `M-x package-refresh-contents` to load the contents of the new repository, 
and `M-x package-install RET ix.el RET` to install `ix.el`.

### Manual
To install, copy `ix.el` to somewhere your emacs can find, on your
load path. Usually something like:

    $ mkdir ~/.emacs.d/ix
    $ cp ix.el ~/.emacs.d/ix.el

However manual installation also requires the emacs package [grapnel](https://github.com/leathekd/grapnel)
in your load-path. Either install that from marmalade package repo or
add it manually to your load path.

To the `user-init-file` (.emacs) add the following:
 
    (add-to-list 'load-path "~/.emacs.d/ix")
    (require 'ix)

`ix` also requires a curl to be in your exec-path.

Usage
-----
The following commands are available

* `ix` - post region\buffer to http://ix.io
* `ix-delete` - (prompts for url/id) delete a user owned post
* `ix-browse` - (prompts for url/id) browse a paste from ix.io

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

To delete a post, calling `ix-delete` will prompt for the post
identifier or the  complete url (of the form http://ix.io/ID), which will delete the post. 
This requires that the post was posted using a username and token

`ix-browse` lets you browse a paste at ix.io. This prompts for url/ID
similiar to `ix-delete`. If point is already on a url then it defaults
to that.

More info
---------
`ix` was built a top of the emacs package [grapnel](https://github.com/leathekd/grapnel)
http request library.

Please report issues, improvements etc. at ix github page

Similiar Projects
-----------------
[emacs-ixio](https://github.com/jorgenschaefer/emacs-ixio) Another simple interface to `ix`, doesn't depend on curl
