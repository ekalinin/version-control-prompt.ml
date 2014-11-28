CHDIR=cd /vagrant
BUILD=ocamlbuild -use-ocamlfind -pkg str -pkg unix -I src main.native -build-dir
INIT_OCAML=. /home/vagrant/.opam/opam-init/init.sh
VM1=vm1x32
VM2=vm2x64

all:
	@ocamlbuild -use-ocamlfind -pkg str -pkg unix -I src main.native
	@mkdir -p bin
	@cp ./_build/src/main.native ./bin/version-control-prompt
	@rm -f ./main.native

clean:
	@rm -rf ./_build/
	@rm -rf ./_build-*

release:
	@git tag `grep -o -E '[0-9]\.[0-9]\.[0-9]{1,2}' src/main.ml`
	@git push --tags origin master

install-local: all
	@cp ./bin/version-control-prompt ~/bin

vagrant-32:
	@vagrant up ${VM1}
	@vagrant ssh -c "${CHDIR} && ${INIT_OCAML} && ${BUILD} _build-32" ${VM1}
	@cp ./_build-32/src/main.native ./bin/version-control-prompt-32

vagrant-64:
	@vagrant up ${VM2}
	@vagrant ssh -c "${CHDIR} && ${INIT_OCAML} && ${BUILD} _build-64" ${VM2}
	@cp ./_build-64/src/main.native ./bin/version-control-prompt-64

show-deps:
	@readelf -d bin/version-control-prompt | grep NEEDED
