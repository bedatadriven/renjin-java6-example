Vagrant.configure(2) do |config|
  config.vm.box = "jeqo/oracle-db-11g"
  config.vm.box_version = "11.2.0.4.20151127142247"

  config.vm.define :oracle do |oracle| 
    oracle.vm.hostname = 'oraclebox'
    oracle.vm.synced_folder ".", "/vagrant", owner: "oracle", group: "oinstall" 
    oracle.vm.network :private_network, ip: '192.168.33.13'
    oracle.vm.network :forwarded_port, guest: 1521, host: 1521
    oracle.vm.provision "shell", path: "shell/provision.sh"
  end

  VAGRANT_COMMAND = ARGV[0]
  if VAGRANT_COMMAND == "ssh"
    config.ssh.username = 'oracledb'
    config.ssh.insert_key = false
  end
end
