# @summary
#   Manages the nginx configuration for knoedel
#
class profile::hosting::knoedel {
  contain profile::nginx

  $www_dir = '/srv/hosting/knoedel-io'

  profile::tools::create_dir { $www_dir:
  }

  nginx::resource::server { 'knoedel-cloud':
    server_name => [
      'knoedel.cloud',
    ],
    http2       => 'on',
    listen_port => 443,
    format_log  => 'anonymized',
    ssl         => true,
    ssl_cert    => '/etc/ssl/certs/knoedel_cloud.crt',
    ssl_key     => '/etc/ssl/private/knoedel_cloud.key',
    www_root    => $www_dir,
    require     => Profile::Tools::Create_dir[$www_dir],
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
