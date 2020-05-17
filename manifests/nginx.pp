# @summary
#   Manages nginx configuration
#
# @param servers
#
class profile::nginx (
  String $dhparam,
  Hash $servers = {},
) {
  class { '::nginx':
    confd_purge               => true,
    server_purge              => true,
    http_access_log           => 'off',
    ssl_protocols             => 'TLSv1.2 TLSv1.3',
    ssl_ciphers               =>
      'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384'
    ,
    ssl_prefer_server_ciphers => 'off',
    ssl_stapling              => 'on',
    ssl_stapling_verify       => 'on',
    ssl_dhparam               => '/etc/nginx/dhparam.pem',
    ssl_session_timeout       => '1d',
    ssl_session_cache         => 'shared:MozSSL:10m',
    ssl_session_tickets       => 'off',
  }

  file { '/etc/nginx/dhparam.pem':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $dhparam,
    notify  => Service['nginx'],
  }

  create_resources('nginx::resource::server', $servers)
}
