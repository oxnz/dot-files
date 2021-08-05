Dot-files
#########

Description
===========

This repo is part of the productivity project by Max.Z

Editors
-------

* emacs (a better emacs config stuff: deprecated)

    * emacs.d

* vim (perlsonal vim config file)

    * vimrc
    * vim (plugins)

Shells
--------

* dotfm.pl

    * used to manage the dot files under user's home directory, ie(~).

* bashrc

    * aliases
    * profile (``PATH``)

* zshrc
* git

    * gitignore

git and vim
-----------

Resolve conflicts

.. code-block::

    git mergetool
    +--------------------------------+
    | LOCAL  |     BASE     | REMOTE |
    +--------------------------------+
    |             MERGED             |
    +--------------------------------+

LOCAL
    this is file from the current branch BASE – common ancestor, how file looked before both changes

REMOTE
    file you are merging into your branch

MERGED
    merge result, this is what gets saved in the repo

Let’s assume that we want to keep the “octodog” change (from REMOTE). For that, move to the MERGED file (Ctrl + w, j), move your cursor to a merge conflict area and then:

.. code-block:: shell

    :diffget RE

This gets the corresponding change from REMOTE and puts it in MERGED file. You can also:

.. code-block:: shell

    :diffg RE  " get from REMOTE
    :diffg BA  " get from BASE
    :diffg LO  " get from LOCAL

Save the file and quit (a fast way to write and quit multiple files is :wqa).

Run git commit and you are all set!

Notes
=====

tree alias

.. code-block:: shell

    find . -print | sed -e 's;[^/]*/;|____;g;s;____|;|;g'

License
=======

The MIT License

See LICENSE for details.

References
==========

* [Shell Special Variables](./sh-spec-var.md)
* [Test if is interactive shell](./test-sh-interact.md)

