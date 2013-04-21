#
# Cookbook Name:: gitlist
# Recipe:: default
#
# Copyright 2013, Ryan Lovelett
#
# All rights reserved - Do Not Redistribute

include_recipe 'git'
include_recipe 'apache2'
include_recipe 'apache2::mod_php5'
include_recipe 'apache2::mod_deflate'
include_recipe 'apache2::mod_rewrite'
include_recipe 'php'
include_recipe 'composer'
include_recipe 'build-essential'
include_recipe 'phpunit'
#include_recipe 'pdepend::composer'
#include_recipe 'phpcpd'
#include_recipe 'phploc'
#include_recipe 'phpmd::composer'

php_pear_channel 'pecl.php.net' do
  action :update
end

php_pear 'xdebug' do
  # Specify that xdebug.so must be loaded as a zend extension
  zend_extensions ['xdebug.so']
  action :install
end

template '/etc/php5/conf.d/xdebug.ini' do
  source 'xdebug.ini.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables({
    :remote_host => node['gitlist']['xdebug_remote_host'],
    :remote_port => node['gitlist']['xdebug_remote_port']
  })
end

link '/var/www/gitlist' do
  to '/vagrant'
  action :create
end

execute 'composer' do
  command 'composer install'
  cwd '/vagrant'
  notifies :reload, 'service[apache2]', :delayed
end

web_app 'gitlist' do
  template 'gitlist.conf.erb'
  notifies :reload, 'service[apache2]', :delayed
end
