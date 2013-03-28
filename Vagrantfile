# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 sw=2 expandtab:

Vagrant.configure("2") do |config|

  box = "precise32"

  nodes = [
    { name: 'rabbit1', ip: '192.168.40.10', mgmt_port: 10010 },
    { name: 'rabbit2', ip: '192.168.40.11', mgmt_port: 10011 },
    { name: 'rabbit3', ip: '192.168.40.12', mgmt_port: 10012 },
  ]

  nodes.each do |node|
    config.vm.define node[:name].to_sym do |rabbit_config|
      rabbit_config.vm.box = box
      rabbit_config.vm.network :forwarded_port, guest: 15672, host: node[:mgmt_port]
      rabbit_config.vm.network :private_network, ip: node[:ip]
      rabbit_config.vm.provision :shell, :path => "rabbitmq.sh"
      rabbit_config.vm.hostname = node[:name]
    end
  end

  config.vm.define :worker do |worker_config|
    worker_config.vm.box = box
    worker_config.vm.network :private_network, ip: "192.168.64.20"
    worker_config.vm.provision :shell, :path => "worker.sh"
    worker_config.vm.hostname = 'worker'
    worker_config.vm.synced_folder "src/", "/srv/"
  end


end
