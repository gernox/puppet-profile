# @summary
#   Manages the nginx configuration for findway
#
class profile::hosting::onlinebase {
  contain profile::nginx

  $www_dir = '/srv/hosting/onlinebase'

  profile::tools::create_dir { $www_dir:
  }

  nginx::resource::server { 'online-base-net':
    server_name => [
      'online-base.net',
    ],
    http2       => 'on',
    listen_port => 443,
    format_log  => 'anonymized',
    ssl         => true,
    ssl_cert    => '/etc/ssl/certs/online_base_net.crt',
    ssl_key     => '/etc/ssl/private/online_base_net.key',
    www_root    => $www_dir,
    require     => Profile::Tools::Create_dir[$www_dir],
  }

  nginx::resource::server { 'online-base-net-redirect':
    server_name         => [
      '*.online-base.net',
    ],
    listen_port         => 443,
    ssl                 => true,
    ssl_cert            => '/etc/ssl/certs/online_base_net.crt',
    ssl_key             => '/etc/ssl/private/online_base_net.key',
    access_log          => 'absent',
    error_log           => 'absent',
    index_files         => [],
    location_cfg_append => {
      rewrite => '^ https://online-base.net permanent',
    },
  }
}
