# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

# ---------------------------------------------------------------------------------------
# Number of nodes to provision
numNodes = 8

ctrlAddr   = "10.0.1.5"
masterAddr = "10.0.1.6"

# IP Address Base for private network
ipAddrBase = "10.0.1.10"

# list of zones
# zones = ["alpha", "bravo", "charlie", "delta", "echo", "foxtrot"]
zones = ["alpha"]

# public key for ansible
id_ssh_key = File.read(File.join(Dir.home, ".ssh", "id_rsa.pub"))
# ---------------------------------------------------------------------------------------

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box_url = "http://files.wunki.org/freebsd-10.0-amd64-wunki.box"
  config.vm.box = "freebsd-10.0-amd64-wunki"
  
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "256"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    
    #vb.gui = true
  end

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.ftp      = "http://10.0.1.5:8000/"
    config.proxy.http     = "http://10.0.1.5:8000/"
    config.proxy.no_proxy = "localhost,127.0.0.1"
  end

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    #config.hostmanager.manage_host = true
    config.hostmanager.include_offline = true
  end

  # ---------------------------------------------------------------------------------------

  config.vm.define "controller" do |controller|
    controller.vm.guest = :freebsd
    controller.vm.hostname = "controller.vac.sys"
    controller.vm.network "private_network", ip: ctrlAddr

    controller.vm.synced_folder ".", "/vagrant", disabled: true
    controller.vm.provision "shell", path: "bootstrap.sh", args: "'#{id_ssh_key}'"
  end

  # ---------------------------------------------------------------------------------------
  pc = 0
  
  zones.each_with_index do |zone, zi|

    pc = pc +2
  
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
        node.vm.provision "shell", path: "bootstrap.sh", args: "'#{id_ssh_key}'"
        
        node.vm.provision "ansible" do |ansible|
          ansible.playbook = "ansible/vac-nodes.yml"
          #ansible.verbose = 'vvvv'
          ansible.host_key_checking = false
          ansible.raw_arguments = ['--private-key=~/.ssh/id_rsa', '--user=root']
          
          pcc  = pc.to_s
          pcn  = (pc + 1).to_s

          ansible.extra_vars = {
              'nfsserver' => '192.168.1.2',
              'nfsmount'  => '/images' ,
              'nfspath'   => '/backup',
              'imagesdir' => '/images/racker',
              'ip_pool'   => "172.16."+ pcc +".0/24 172.16."+ pcn +".0/24",
              
              'ansible_ssh_user' => 'root'
          }
          
        end
      end
    end
  end
  
  # master at the end so it can register nodes by itself using /etc/hosts file filled up with vagrant plugin

  config.vm.define "master" do |master|
    master.vm.guest = :freebsd
    master.vm.hostname = "master.vac.sys"
    master.vm.network "private_network", ip: masterAddr

    # let's disable NFS shares for now
    master.vm.synced_folder ".", "/vagrant", disabled: true
    master.vm.provision "shell", path: "bootstrap.sh", args: "'#{id_ssh_key}'"

    master.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/vac-master.yml"
      #ansible.verbose = 'vvvv'
      ansible.host_key_checking = false
      ansible.raw_arguments = ['--private-key=~/.ssh/id_rsa', '--user=root']

      ansible.extra_vars = {
          'nfsserver' => '192.168.1.2',
          'nfsmount'  => '/images' ,
          'nfspath'   => '/backup',
          'imagesdir' => '/images/racker',
          'ip_pool'   => "172.16.0.0/24 172.16.1.0/24",

          'ansible_ssh_user' => 'root'
      }

    end
  end
  
end
