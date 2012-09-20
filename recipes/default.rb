#
# Cookbook Name:: Drupal Memcache
# Recipe:: default
#
# Copyright 2012, Dracars Designs
#
# All rights reserved - Do Not Redistribute
#
# To-Do add attributes to abstract values

include_recipe "php"
include_recipe "memcached"

execute "download-and-enable-memcache-module" do
  cwd "#{ node['drupal']['dir'] }/sites/default"
  command "drush dl -y memcache --destination=sites/all/modules/contrib/; \
           drush en -y memcache;"
end

template "#{ node['drupal']['dir'] }/memcache.conf" do
  source "memcache.conf.erb"
  mode 0755
  not_if do
    File.exists?("#{ node['drupal']['dir'] }/memcache.conf")
  end
end

execute "append-memcache-config-to-bottom-of-settings.php" do
  cwd "#{ node['drupal']['dir'] }/sites/default"
  command "cp settings.php settings.php.memcache; \
           cat #{ node['drupal']['dir'] }/memcache.conf >> settings.php.memcache; \
           mv settings.php.memcache settings.php;"
end
