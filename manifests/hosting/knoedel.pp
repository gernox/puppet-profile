# @summary
#   Manages the nginx configuration for knoedel
#
class profile::hosting::knoedel {
  contain profile::nginx

  $www_dir = '/srv/hosting/knoedel-io'

  profile::tools::create_dir { $www_dir:
  }

  nginx::resource::server { 'knoedel-io-ssl-redirect':
    server_name         => [
      'knoedel.io',
    ],
    listen_port         => 443,
    ssl                 => true,
    ssl_cert            => '/etc/ssl/certs/knoedel_io.crt',
    ssl_key             => '/etc/ssl/private/knoedel_io.key',
    access_log          => 'absent',
    error_log           => 'absent',
    index_files         => [],
    location_cfg_append => {
      rewrite => '^ https://knoedel.io permanent',
    },
  }

  nginx::resource::server { 'knoedel-io':
    server_name => [
      'knoedel.io',
    ],
    http2       => 'on',
    listen_port => 443,
    format_log  => 'anonymized',
    ssl         => true,
    ssl_cert    => '/etc/ssl/certs/knoedel_io.crt',
    ssl_key     => '/etc/ssl/private/knoedel_io.key',
    www_root    => $www_dir,
    require     => Profile::Tools::Create_dir[$www_dir],
  }
}
