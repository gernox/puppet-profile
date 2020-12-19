# @summary
#   Manages the nginx configuration for uo-scripts
#
class profile::hosting::uoscripts {
  contain profile::nginx

  $www_dir = '/srv/hosting/uo-scripts'

  profile::tools::create_dir { $www_dir:
  }

  nginx::resource::server { 'uo-scripts-de':
    server_name => [
      'uo-scripts.de',
    ],
    http2       => 'on',
    listen_port => 443,
    format_log  => 'anonymized',
    ssl         => true,
    ssl_cert    => '/etc/ssl/certs/uo_scripts_de.crt',
    ssl_key     => '/etc/ssl/private/uo_scripts_de.key',
    www_root    => $www_dir,
    require     => Profile::Tools::Create_dir[$www_dir],
  }

  nginx::resource::server { 'uo-scripts-de-redirect':
    server_name         => [
      '*.uo-scripts.de',
    ],
    listen_port         => 443,
    ssl                 => true,
    ssl_cert            => '/etc/ssl/certs/uo_scripts_de.crt',
    ssl_key             => '/etc/ssl/private/uo_scripts_de.key',
    access_log          => 'absent',
    error_log           => 'absent',
    index_files         => [],
    location_cfg_append => {
      rewrite => '^ https://uo-scripts.de permanent',
    },
  }
}
