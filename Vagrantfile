# -*- mode: ruby -*-
# vi: set ft=ruby :

require "vagrant"

if Vagrant::VERSION < "1.2.1"
  raise "The Omnibus Build Lab is only compatible with Vagrant 1.2.1+"
end

host_project_path = File.expand_path("..", __FILE__)
guest_project_path = "/home/vagrant/#{File.basename(host_project_path)}"
project_name = "datadog-agent"

Vagrant.configure("2") do |config|

  config.vm.hostname = "#{project_name}-omnibus-build-lab.com"

  # Let's cache stuff to reduce build time using vagrant-cachier
  # Require vagrant-cachier plugin
  config.cache.scope = :box

 vms_to_use = {
    'ubuntu-x64' => 'ubuntu-14.04'
    }

  vms_to_use.each_pair do |key, platform|

    config.vm.define key do |c|
      c.vm.box = "opscode-#{platform}"
      c.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_#{platform}_chef-provisionerless.box"
    end

  end

  config.vm.provider :virtualbox do |vb|
    # Give enough horsepower to build without taking all day.
    vb.customize [
      "modifyvm", :id,
      "--memory", "3072",
      "--cpus", "3",
      "--ioapic", "on" # Required for the centos-5-32 bits to boot
    ]
  end

  # Ensure a recent version of the Chef Omnibus packages are installed
  config.omnibus.chef_version = "11.16.4"

  # Enable the berkshelf-vagrant plugin
  config.berkshelf.enabled = true
  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile"

  config.ssh.forward_agent = true

  # Mount omnibus to have the builder code!
  current_dir = File.expand_path('..', __FILE__)
  config.vm.synced_folder current_dir, '/home/vagrant/dd-agent-omnibus'
  config.vm.synced_folder '/Users/bao/fastly/docker-dd-agent-build-rpm-i386', '/home/vagrant/docker-dd-agent'
  # Mount local agent repo if asked to
  if ENV['LOCAL_AGENT_REPO']
    config.vm.synced_folder ENV['LOCAL_AGENT_REPO'], '/home/vagrant/dd-agent'
    # For the VM replace by the new path where we mounted it
    ENV['LOCAL_AGENT_REPO'] = '/home/vagrant/dd-agent'
  end

  # prepare VM to be an Omnibus builder
  config.vm.provision :chef_solo do |chef|
    chef.custom_config_path = "Vagrantfile.chef"
    chef.json = {
      "omnibus" => {
        "build_user" => "vagrant",
        "build_dir" => guest_project_path,
        "install_dir" => "/opt/#{project_name}"
      },
      "go" => {
        "version" => "1.2.2",
        "scm" => false
      },
    }

    chef.run_list = [
      "recipe[golang]"
    ]
  end

  # Export the defaults we need to run the scripts
  # No better way of passing args in the VM :/
  profile_file = "/etc/profile.d/vagrant.sh"
  env_variables_script = <<ENVSCRIPT
rm -f #{profile_file}
echo "# vagrant profile script" > #{profile_file}
ENVSCRIPT
  env_variables_passthru = %w[
    AGENT_BRANCH
    AGENT_VERSION
    DISTRO
    LOCAL_AGENT_REPO
    LOG_LEVEL
    S3_OMNIBUS_BUCKET
    S3_ACCESS_KEY
    S3_SECRET_KEY
  ]
  env_variables_passthru.each do |var|
    env_variables_script += "\necho export #{var}=#{ENV[var]} >> #{profile_file}"
  end
  config.vm.provision 'shell', inline: env_variables_script
  config.vm.provision 'shell', inline: 'sudo apt-get update; sudo apt-get install -y curl git'
  config.vm.provision 'shell', inline: 'curl -sSL https://get.docker.com/ | sh && sudo usermod -aG docker vagrant'

  # # Do the real work, build it!
  # config.vm.provision 'shell', path: 'omnibus_build.sh'
  #
  # if ENV['CLEAR_CACHE'] == "true"
  #   config.vm.provision "shell",
  #     inline: "echo Clearing Omnibus cache && rm -rf /var/cache/omnibus/*"
  # end
end
