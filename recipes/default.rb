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

php_pear "memcache" do
  action :install
end

#execute "download-and-enable-memcache-module" do
#  cwd "#{ node[:drupal][:dir] }/sites/default"
#  command "drush dl memcache; \
#           drush en -y memcache;"
#end

template "#{ node[:drupal][:dir] }/memcache.conf" do
  source "memcache.conf"
  mode 0755
  not_if do
    File.exists?("#{ node[:drupal][:dir] }/memcache.conf")
  end
end

execute "do stuff" do
  cwd "#{ node[:drupal][:dir] }/sites/default"
  command "cp settings.php settings.php.tmp; \
           cat #{ node[:drupal][:dir] }/memcache.conf >> settings.php.tmp; \
           mv settings.php.tmp settings.php;"
end

#bash "append-memcache-config-to-settings.php" do
#  cwd "#{ node[:drupal][:dir] }/sites/default"
#  code <<-EOH
#  cp settings.php settings.php.tmp
#  cat <<\EOF >> settings.php.tmp
#  // Add Memcache as the page cache handler.
#  $conf['cache_backends'][] = 'sites/all/modules/contrib/memcache/memcache.inc';
#  $conf['cache_default_class'] = 'MemCacheDrupal';
#  $conf['cache_class_cache_form'] = 'DrupalDatabaseCache';'
#  EOF
#  mv settings.php.tmp settings.php
#  EOH
#end
