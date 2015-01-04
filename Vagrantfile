# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

# ---------------------------------------------------------------------------------------
# Number of nodes to provision
numNodes = 2

ctrlAddr   = "10.0.1.5"
masterAddr = "10.0.1.6"

# IP Address Base for private network
ipAddrBase = "10.0.1.10"

# list of zones
# zones = ["alpha", "bravo", "charlie", "delta", "echo", "foxtrot"]
zones = ["alpha", "bravo"]
# ---------------------------------------------------------------------------------------

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "freebsd-10.0-amd64-wunki"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "256"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
  end

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.ftp      = "http://10.0.1.5:8000/"
    config.proxy.http     = "http://10.0.1.5:8000/"
    config.proxy.no_proxy = "localhost,127.0.0.1"
  end

  # ---------------------------------------------------------------------------------------

  config.vm.define "controller" do |controller|
    controller.vm.guest = :freebsd
    controller.vm.hostname = "controller.vac.sys"
    controller.vm.network "private_network", ip: ctrlAddr

    controller.vm.synced_folder ".", "/vagrant", disabled: true
    controller.vm.provision "shell", path: "vagrant/controller.sh"
  end

  config.vm.define "master" do |master|
    master.vm.guest = :freebsd
    master.vm.hostname = "master.vac.sys"
    master.vm.network "private_network", ip: masterAddr

    master.vm.synced_folder ".", "/vagrant", :nfs => true, id: "vagrant-root"
    master.vm.provision "shell", path: "vagrant/master.sh"
  end

  # ---------------------------------------------------------------------------------------

  zones.each_with_index do |zone, zi|
    1.upto(numNodes) do |ni|
      config.vm.define "node#{ni}-#{zone}" do |node|
        node.vm.guest = :freebsd
        node.vm.hostname = "node#{ni}.#{zone}.vac.sys"

        ipArr = ipAddrBase.split(".")
        ipArr[2] = ipArr[2].to_i + zi
        ipArr[3] = ipArr[3].to_i + ni

        node.vm.network "private_network", ip: ipArr.join(".")

        # let's disable NFS shares for now
        node.vm.synced_folder ".", "/vagrant", disabled: true
        node.vm.provision "shell", inline: "echo hello from node #{ni} in zone #{zone}"
      end
    end
  end
  
end
