all:
	@mkdir -p bin
	@(cd src && ocamlfind ocamlopt \
					-package str,unix \
					-linkpkg \
					utils.ml scm.ml main.ml \
					-o ../bin/version-control-prompt)

clean:
	@rm -f ./src/*.cmx
	@rm -f ./src/*.o
	@rm -f ./src/*.cmi

release:
	@git tag `grep -o -E '[0-9]\.[0-9]\.[0-9]{1,2}' src/main.ml`
	@git push --tags origin master
