# @summary
#   Manages the nginx configuration for gernox
#
class profile::hosting::gernox {
  contain profile::nginx

  $www_dir = '/srv/hosting/gernox'

  profile::tools::create_dir { $www_dir:
  }

  nginx::resource::server { 'gernox-de':
    server_name => [
      'gernox.de',
    ],
    http2       => 'on',
    listen_port => 443,
    format_log  => 'anonymized',
    ssl         => true,
    ssl_cert    => '/etc/ssl/certs/gernox_de.crt',
    ssl_key     => '/etc/ssl/private/gernox_de.key',
    www_root    => $www_dir,
    require     => Profile::Tools::Create_dir[$www_dir],
  }

  nginx::resource::server { 'gernox-de-redirect':
    server_name         => [
      'www.gernox.de',
    ],
    listen_port         => 443,
    ssl                 => true,
    ssl_cert            => '/etc/ssl/certs/gernox_de.crt',
    ssl_key             => '/etc/ssl/private/gernox_de.key',
    access_log          => 'absent',
    error_log           => 'absent',
    index_files         => [],
    location_cfg_append => {
      rewrite => '^ https://gernox.de permanent',
    },
  }

  nginx::resource::server { 'gernox-it-redirect':
    server_name         => [
      'gernox.it',
      'www.gernox.it',
    ],
    listen_port         => 443,
    ssl                 => true,
    ssl_cert            => '/etc/ssl/certs/gernox_it.crt',
    ssl_key             => '/etc/ssl/private/gernox_it.key',
    access_log          => 'absent',
    error_log           => 'absent',
    index_files         => [],
    location_cfg_append => {
      rewrite => '^ https://gernox.de permanent',
    },
  }
}
