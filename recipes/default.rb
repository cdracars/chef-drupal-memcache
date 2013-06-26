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

node.default['php']['directives'] = [:extension => memcached.so]

#execute "append-memcache-config-to-bottom-of-settings.php" do
#  cwd "#{ node['drupal']['dir'] }/sites/default"
#  command "cp settings.php settings.php.memcache; \
#           cat #{ node['drupal']['dir'] }/memcache.conf >> settings.php.memcache; \
#           mv settings.php.memcache settings.php;"
#  not_if "grep MemCacheDrupal settings.php"
#end

ruby_block "append-memcache-config-to-bottom-of-settings.php" do
  block do
    file = Chef::Util::FileEdit.new("#{ node['drupal']['dir'] }/memcache.conf")
    file.insert_line_if_no_match(
      "// Add Memcache as the page cache handler.",
      "\n$conf['cache_backends'][] = 'sites/all/modules/contrib/memcache/memcache.inc';
       \n$conf['cache_default_class'] = 'MemCacheDrupal';
       \n$conf['cache_class_cache_form'] = 'DrupalDatabaseCache';"
    )
    file.write_file
  end
end
