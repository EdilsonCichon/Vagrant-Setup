# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = true

  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "forwarded_port", guest: 22, host: 2220

  # https://www.vagrantup.com/docs/provisioning/shell.html

  config.vm.provision :shell, :path => "install.sh"

  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=755", "fmode=666"]

end
