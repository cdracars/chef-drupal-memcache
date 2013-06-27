#
# Cookbook Name:: Drupal Memcache
# Recipe:: default
#
# Copyright 2012, Dracars Designs
#
# All rights reserved - Do Not Redistribute
#
# To-Do add attributes to abstract values

include_recipe "drupal"
include_recipe "memcached"
include_recipe "php::module_memcache"

execute "download-memcache-module" do
  cwd "#{ node['drupal']['dir'] }/sites/default"
  command "drush dl -y memcache --destination=sites/all/modules/contrib/;"
  not_if "drush pml --no-core --type=module | grep memcache"
end

execute "enable-memcache-module" do
  cwd "#{ node['drupal']['dir'] }/sites/default"
  command "drush en -y memcache;"
  not_if "drush pml --no-core --type=module --status=enabled | grep memcache"
end

node.default['php']['directives']['extension'] = ['memcached.so']

conf_plain_file "#{ node['drupal']['dir'] }/sites/default/settings.php" do
  pattern /\/\/ Add Memcache as the page cache handler./
  new_line "\n// Add Memcache as the page cache handler.
  \n$conf['cache_backends'][] = 'sites/all/modules/contrib/memcache/memcache.inc';
  $conf['cache_default_class'] = 'MemCacheDrupal';
  $conf['cache_class_cache_form'] = 'DrupalDatabaseCache';"
  action :insert_if_no_match
end
