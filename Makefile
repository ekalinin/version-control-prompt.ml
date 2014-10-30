all:
	@mkdir -p bin
	@(cd src && ocamlopt str.cmxa -o ../bin/version-control-prompt scm.ml main.ml)
