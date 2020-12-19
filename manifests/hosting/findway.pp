# @summary
#   Manages the nginx configuration for findway
#
class profile::hosting::findway {
  contain profile::nginx

  $www_dir = '/srv/hosting/findway'

  profile::tools::create_dir { $www_dir:
  }

  nginx::resource::server { 'findway-de':
    server_name => [
      'findway.de',
    ],
    http2       => 'on',
    listen_port => 443,
    format_log  => 'anonymized',
    ssl         => true,
    ssl_cert    => '/etc/ssl/certs/findway_de.crt',
    ssl_key     => '/etc/ssl/private/findway_de.key',
    www_root    => $www_dir,
    require     => Profile::Tools::Create_dir[$www_dir],
  }

  nginx::resource::server { 'findway-de-redirect':
    server_name         => [
      '*.findway.de',
    ],
    listen_port         => 443,
    ssl                 => true,
    ssl_cert            => '/etc/ssl/certs/findway_de.crt',
    ssl_key             => '/etc/ssl/private/findway_de.key',
    access_log          => 'absent',
    error_log           => 'absent',
    index_files         => [],
    location_cfg_append => {
      rewrite => '^ https://findway.de permanent',
    },
  }
}
