version-control-prompt.ml
=========================

Shell prompt for version control systems (git, hg, svn)

Screenshot
----------
Here is an example of the prompt in gnome-terminal:

![Example](https://raw.github.com/ekalinin/version-control-prompt.ml/master/screenshot.png)

Dependencies
------------

Only Ocaml's core. Installation on Ubuntu:

```bash
$ sudo add-apt-repository ppa:avsm/ppa
$ sudo apt-get update
$ sudo apt-get install ocaml opam
$ opam install core
```

How to build
------------

```bash
$ git clone https://github.com/ekalinin/version-control-prompt.ml.git
$ cd version-control-prompt.ml
$ make
$ ls bin/
version-control-prompt
```

How to use
----------

Copy binary in some constant path, for example ``~/bin``:

```bash
$ mkdir -p ~/bin
$ cp bin/version-control-prompt ~/bin
```

For bash, add the follow in your ``~/.bashrc``:

```bash

PURPLE2="\033[1;35m"
RESET="\033[m"

vc_prompt() {
    local vc_prompt=$(~/bin/version-control-prompt)
    if [ "$vc_prompt"  != "" ]; then
        echo -e "on $PURPLE2$vc_prompt$RESET"
    fi
}


PS1='\u@\h:\w $(vc_prompt)\$ '
```

Default format string:

```
%type|%branch|%status %stats
```

You can override id like this:

```bash
# ...

vc_prompt() {
    local vc_prompt=$(~/bin/version-control-prompt --fmt "(%type:%branch:%status)")
    if [ "$vc_prompt"  != "" ]; then
        echo -e "on $PURPLE2$vc_prompt$RESET"
    fi
}

# ...
```


LICENSE
=======

MIT / [LICENSE](https://github.com/ekalinin/version-control-prompt.ml/blob/master/LICENSE)
