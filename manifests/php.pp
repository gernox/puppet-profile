# @summary
#   Manages php configuration
#
class profile::php (
  String $version,
  Hash $fpm_pools,
  Hash $extensions,
  Hash $settings,
) {
  class { '::php::globals':
    php_version => $version,
    config_root => "/etc/php/${version}",
  }
  -> class { '::php':
    manage_repos => false,
    fpm          => true,
    fpm_pools    => $fpm_pools,
    dev          => true,
    composer     => true,
    extensions   => $extensions,
    settings     => $settings,
  }
}
