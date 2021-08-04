#########
dot-files
#########

Description
===========

This repo is part of the productivity project by Max.Z

Contents
--------

* dotfm.pl

    * used to manage the dot files under user's home directory, ie(~).

* bashrc

    * aliases
    * profile (``PATH``)

* zshrc
* git

    * gitignore

* emacs (a better emacs config stuff: deprecated)

    * emacs.d

* vim (perlsonal vim config file)

    * vimrc
    * vim

Notes
=====

tree alias

.. code-block:: shell

    find . -print | sed -e 's;[^/]*/;|____;g;s;____|;|;g'

License
=======

[The MIT License](./LICENSE)

##References

* [Shell Special Variables](./sh-spec-var.md)
* [Test if is interactive shell](./test-sh-interact.md)
