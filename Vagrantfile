Vagrant.configure("2") do |config|
  config.vm.box = "gusztavvargadr/ubuntu-desktop-2204-lts"
  config.vm.box_version = "2506.0.0"
  config.vm.provision "shell",
	 inline:"sudo apt-get update && sudo apt-get install -y puppet"

config.vm.define :db do |db_config|
	db_config.vm.network :private_network, :ip => "192.168.56.10"
	db_config.vm.provision "puppet" do |puppet|
		puppet.manifest_file = "db.pp"
	end
end

config.vm.define :web do |web_config|
  web_config.vm.network :private_network, :ip => "192.168.56.12"
  web_config.vm.provider "virtualbox" do |vb|
  	vb.memory = 4000  # Change this value as needed, e.g., 4096 for 4GB RAM
  web_config.vm.provision "puppet" do |puppet|
	puppet.manifest_file = "web.pp"	 
	end
  end
end

config.vm.define :monitor do |monitor_config|
monitor_config.vm.network :private_network, :ip => "192.168.56.14"
end


end
