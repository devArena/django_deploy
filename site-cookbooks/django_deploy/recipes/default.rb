require 'rubygems'
require 'json'

app_name = node['django_deploy']['app_name']
is_debug = node['django_deploy']['is_debug']
sql_host = node['django_deploy']['sql_host']
sql_port = node['django_deploy']['sql_port']
sql_username = node['django_deploy']['sql_username']
sql_password = node['django_deploy']['sql_password']
nginx_host = node['django_deploy']['nginx_host']
nginx_port = node['django_deploy']['nginx_port']
nginx_domain = node['django_deploy']['nginx_domain']
git_repo = node['django_deploy']['git_repo']
git_revision = node['django_deploy']['git_revision']
django_local_settings = node['django_deploy']['django_local_settings']
django_requirements = node['django_deploy']['django_requirements']
django_requirements_additional = node['django_deploy']['django_requirements_additional']
django_database_name = node['django_deploy']['django_database_name']
gunicorn_host = node['django_deploy']['gunicorn_host']
gunicorn_port = node['django_deploy']['gunicorn_port']

node.default['postgresql']['password']['postgres'] = sql_password
node.default['nginx']['install_method'] = "package"

include_recipe "apt"
include_recipe "git"
include_recipe "vim"
include_recipe "nginx"
include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "database"
include_recipe "database::postgresql"
include_recipe "application"

#include_recipe "memcached"
#include_recipe "rabbitmq"

postgresql_connection_info = {
    :host      => sql_host,
    :port      => sql_port,
    :username  => sql_username,
    :password  => sql_password,
}

database app_name do
    connection postgresql_connection_info
    provider   Chef::Provider::Database::Postgresql
    action :create
end

service 'postgresql' do
  supports :restart => true
  action :restart
end

template "/etc/nginx/sites-available/#{app_name}.conf" do
  source "nginx-conf.erb"
  owner "root"
  group "root"
  variables(
    :host => nginx_host,
    :port =>  nginx_port,
    :domain =>  nginx_domain,
    :app_home => "/srv/#{app_name}/current",
    :env_home => "/srv/#{app_name}/shared/env",
    :app_name => app_name
    )
  notifies :restart, "service[nginx]"
end

nginx_site "default" do
    enable false
end

nginx_site "#{app_name}.conf"

service 'nginx' do
  supports :restart => true, :reload => true
  action :enable
end

directory "/srv/#{app_name}/shared" do
    owner "root"
    group "root"
    mode '0755'
    recursive true
end

application app_name do
    path "/srv/#{app_name}"
    owner "root"
    group "root"
    repository  git_repo
    revision  git_revision
    symlink_before_migrate "#{django_local_settings}"=>"project/#{django_local_settings}"
    symlinks("#{django_local_settings}"=>"project/#{django_local_settings}")
    migrate true
    #migration_command "/srv/djangoodle/shared/env/bin/python manage.py migrate #{app_name}"
    migration_command "/srv/djangoodle/shared/env/bin/python manage.py syncdb --migrate --noinput"

    django do
        requirements django_requirements
        packages django_requirements_additional
        settings_template "settings.py.erb"
        debug is_debug
        local_settings_file "project/#{django_local_settings}"
        collectstatic "collectstatic --noinput"
        settings :cache =>
        {
            :type => cache_type,
            :location => cache_location
        }
        database do
            database django_database_name
            adapter  'postgresql_psycopg2'
            username sql_username
            password sql_password
            host sql_host
            port sql_port
        end
        #database_host   "localhost"
        #database_name   "djangoodle"
        #database_engine  "postgresql_psycopg2"
        #database_username  "postgres"
        #allowed_hosts "[\"#{node.site_domain}\", \"#{node.ec2_dns}\"]"
        #database_password  "test1234"
    end

    gunicorn do
        #only_if { node['roles'].include? 'application_server' }
        app_module  "project.wsgi"
        #environment(
        #:PYTHONPATH => "/usr/local/bin:/srv/djangoodle/shared/env/local/bin"
        #)
        virtualenv "/srv/#{app_name}/shared/env/local"
        #environment "PYTHONPATH=/srv/djangoodle/shared/env/local/bin"
        logfile "gunicorn.log"
        #bind "unix:/tmp/gunicorn_#{node.site_domain}.sock"
        #bind "unix:/tmp/gunicorn_djangoodle.sock"
        host gunicorn_host
        port gunicorn_port
        autostart true
    end

end
    