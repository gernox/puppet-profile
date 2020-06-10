# @summary
#   Manages php configuration
#
class profile::php (
  String $version,
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
    extensions   => {
      apcu  => {
        package_name => 'php-apcu',
      },
      bcmath   => {},
      bz2      => {},
      curl     => {},
      gd       => {},
      gmp      => {},
      imagick  => {
        package_name => 'php-imagick',
      },
      intl     => {},
      mbstring => {},
      pgsql    => {},
      xmlrpc   => {},
      zip      => {},
    },
    settings     => {
      'PHP/max_execution_time'  => '90',
      'PHP/max_input_time'      => '300',
      'PHP/memory_limit'        => '64M',
      'PHP/post_max_size'       => '32M',
      'PHP/upload_max_filesize' => '32M',
      'Date/date.timezone'      => 'Europe/Berlin',
    },
  }
}
