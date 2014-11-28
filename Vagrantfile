# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
sudo add-apt-repository ppa:avsm/ppa
sudo apt-get update -y
sudo apt-get install ocaml opam m4 -y
opam init
opam switch install 4.01.0
opam install core -y
echo ". /home/vagrant/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> /home/vagrant/.bashrc
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box_check_update = false
  config.vm.provision :shell, :privileged => false, inline: $script

  config.vm.define "vm1x32" do |vm1|
    vm1.vm.hostname = "vm1x32"
    vm1.vm.box = "ubuntu/trusty32"
  end

  config.vm.define "vm2x64" do |vm2|
    vm2.vm.hostname = "vm2x64"
    vm2.vm.box = "ubuntu/trusty64"
  end

end
