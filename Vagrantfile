VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 config.vm.define :djangovm do |django_config|

  app_name = "app_name"
  django_config.vm.box = "precise32"

  django_config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.omnibus.chef_version = :latest

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8000, host: 8001
 
  config.vm.synced_folder "srv", "/srv/" + app_name + "/current", create: true

  django_config.vm.provision :chef_solo do |chef|
    
    chef.cookbooks_path = ['cookbooks','site-cookbooks']

    chef.json = { 
      :django_deploy =>{ 
        "app_name" => app_name,
        "sql_password" => "test1234",
        "git_repo" => "https://github.com/devArena/" + app_name + ".git",
        "django_database_name" => app_name   
      }      
    }

    chef.add_recipe "django_deploy"

  end  
 end
end
