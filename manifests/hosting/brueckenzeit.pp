# @summary
#   Manages the nginx configuration for brueckenzeit
#
class profile::hosting::brueckenzeit {
  contain profile::nginx

  $www_dir = '/srv/hosting/brueckenzeit'

  profile::tools::create_dir { $www_dir:
  }

  nginx::resource::server { 'brueckenzeit-de':
    server_name => [
      'brueckenzeit.de',
    ],
    http2       => 'on',
    listen_port => 443,
    format_log  => 'anonymized',
    ssl         => true,
    ssl_cert    => '/etc/ssl/certs/brueckenzeit_de.crt',
    ssl_key     => '/etc/ssl/private/brueckenzeit_de.key',
    www_root    => $www_dir,
    require     => Profile::Tools::Create_dir[$www_dir],
  }

  nginx::resource::server { 'brueckenzeit-de-redirect':
    server_name         => [
      '*.brueckenzeit.de',
    ],
    listen_port         => 443,
    ssl                 => true,
    ssl_cert            => '/etc/ssl/certs/brueckenzeit_de.crt',
    ssl_key             => '/etc/ssl/private/brueckenzeit_de.key',
    access_log          => 'absent',
    error_log           => 'absent',
    index_files         => [],
    location_cfg_append => {
      rewrite => '^ https://brueckenzeit.de permanent',
    },
  }
}
