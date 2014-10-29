all:
	@mkdir -p bin
	@#ocamlopt -c src/scm.ml
	@#ocamlopt -c src/main.ml
	@#ocamlopt -o bin/version-control-prompt src/scm.cmx src/main.cmx
	@#ocamlopt -o bin/version-control-prompt src/scm.ml src/main.ml
	@(cd src && ocamlopt -o ../bin/version-control-prompt scm.ml main.ml)
