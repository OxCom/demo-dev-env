# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

VM_BOX_IMAGE = "ubuntu/bionic64"
VM_BOX_VERSION = "20200311.0.0"

Vagrant.configure("2") do |config|
  config.vm.box = VM_BOX_IMAGE
  config.vm.box_version = VM_BOX_VERSION
  config.vm.hostname = "dev.lo"

  config.vm.provider :virtualbox do |v|
    v.name = "ubuntu-work"
    v.customize ["modifyvm", :id, "--memory", 4096]
    v.customize ["modifyvm", :id, "--cpus", 4]
    # Prevent VirtualBox from interfering with host audio stack
    v.customize ["modifyvm", :id, "--audio", "none"]
  end

  # before
  config.trigger.before :up do |trigger|
    trigger.info = "Prepare box folder"
    Dir.glob('./*.log').each { |file| FileUtils.rm_rf(file)}
    FileUtils.rm_rf('./box/puppet')
    FileUtils.copy_entry "./puppet-ctrl", "./box/puppet"
  end

  # Provision
  config.vm.synced_folder "./box/puppet", "/etc/puppetlabs/puppet/"
  config.vm.provision :shell, path: "./scripts/vagrant-bootstrap.sh"
end
