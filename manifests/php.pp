# @summary
#   Manages php configuration
#
class profile::php (
  String $version,
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
    dev          => true,
    composer     => true,
    extensions   => $extensions,
    settings     => $settings,
  }
}
