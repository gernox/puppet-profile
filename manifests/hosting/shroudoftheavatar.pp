# @summary
#   Manages the nginx configuration for findway
#
class profile::hosting::shroudoftheavatar {
  contain profile::nginx

  $www_dir = '/srv/hosting/shroudoftheavatar'

  profile::tools::create_dir { $www_dir:
  }

  nginx::resource::server { 'shroudoftheavatar-de':
    server_name => [
      'shroudoftheavatar.de',
    ],
    http2       => 'on',
    listen_port => 443,
    format_log  => 'anonymized',
    ssl         => true,
    ssl_cert    => '/etc/ssl/certs/shroudoftheavatar_de.crt',
    ssl_key     => '/etc/ssl/private/shroudoftheavatar_de.key',
    www_root    => $www_dir,
    require     => Profile::Tools::Create_dir[$www_dir],
  }

  nginx::resource::server { 'shroudoftheavatar-de-redirect':
    server_name         => [
      '*.shroudoftheavatar.de',
    ],
    listen_port         => 443,
    ssl                 => true,
    ssl_cert            => '/etc/ssl/certs/shroudoftheavatar_de.crt',
    ssl_key             => '/etc/ssl/private/shroudoftheavatar_de.key',
    access_log          => 'absent',
    error_log           => 'absent',
    index_files         => [],
    location_cfg_append => {
      rewrite => '^ https://shroudoftheavatar.de permanent',
    },
  }
}
