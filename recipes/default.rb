#
# Cookbook Name:: gitlist
# Recipe:: default
#
# Copyright 2013, Ryan Lovelett
#
# All rights reserved - Do Not Redistribute

include_recipe 'apache2'
include_recipe 'apache2::mod_php5'
include_recipe 'apache2::mod_deflate'
include_recipe 'apache2::mod_rewrite'
include_recipe 'php'
include_recipe 'composer'
include_recipe 'pdepend::composer'
include_recipe 'phpunit'
include_recipe 'phpcpd'
include_recipe 'phploc'
include_recipe 'phpmd::composer'

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
