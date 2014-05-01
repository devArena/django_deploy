VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 config.vm.define :djangovm do |django_config|
 
  config.omnibus.chef_version = :latest

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8000, host: 8001
 
  django_config.vm.provision :chef_solo do |chef|
    
    chef.cookbooks_path = ['cookbooks','site-cookbooks']

    chef.json = { 
      :django_deploy =>{ 
        "app_name" => "djangoodle",
        "sql_password" => "test1234",
        "git_repo" => "https://github.com/devArena/djangoodle.git",
        "django_database_name" => "djangoodle"    
      }      
    }

    chef.add_recipe "django_deploy"

  end  
 end
end
