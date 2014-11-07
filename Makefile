all:
	@ocamlbuild -use-ocamlfind -pkg str -pkg unix -I src main.native
	@mkdir -p bin
	@cp ./_build/src/main.native ./bin/version-control-prompt
	@rm -f ./main.native

clean:
	@rm -rf ./_build/

release:
	@git tag `grep -o -E '[0-9]\.[0-9]\.[0-9]{1,2}' src/main.ml`
	@git push --tags origin master

install-local: all
	@cp ./bin/version-control-prompt ~/bin
