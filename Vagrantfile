# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  dir = File.dirname(File.expand_path(__FILE__)) #actual directory

  #------------------------------------------------------------------------------------
  # CUSTOM PROVISION
  #------------------------------------------------------------------------------------

  config.vm.box = "ubuntu/trusty64"

  config.vm.provision :shell, path: "vagrant_config/vagrant_provision_install.sh"

  config.vm.provision :shell, path: "vagrant_config/vagrant_boot.sh", run: "always"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

  # NETWORKING
  config.vm.network "private_network", ip: "192.168.56.101"

  #SYNC
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "vagrant_config", "/home/vagrant/config"
  config.vm.synced_folder "projects", "/var/www/projects", owner: "vagrant", group: "www-data", mount_options: ["dmode=777,fmode=777"]


  #------------------------------------------------------------------------------------
  # VAGRANT PLUGINS
  #------------------------------------------------------------------------------------
  required_plugins = %w(vagrant-hostmanager)

  plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
  if not plugins_to_install.empty?
    puts "Installing plugins: #{plugins_to_install.join(' ')}"
    if system "vagrant plugin install #{plugins_to_install.join(' ')}"
      exec "vagrant #{ARGV.join(' ')}"
    else
      abort "Installation of one or more plugins has failed. Aborting."
    end
  end

  #------------------------------------------------------------------------------------
  # HOST MANAGER
  #------------------------------------------------------------------------------------

  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = false
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    config.hostmanager.aliases = %w(arepas.app)
  end

  #------------------------------------------------------------------------------------
  # MESSAGE OF THE DAY
  #------------------------------------------------------------------------------------
  case ARGV[0]
    when "provision", "up"
      contents = File.open("#{dir}/MOTD.md", 'r'){ |file| file.read }
      puts "\n\033[32m#{contents}\033[0m\n"
  end
  #------------------------------------------------------------------------------------

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  #config.vm.box = "base"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"


end
