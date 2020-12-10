# @summary
#   Manages nginx configuration
#
# @param servers
#
class profile::nginx (
  String $dhparam,
  Hash $servers                     = {},
  Boolean $enable_default_site      = true,
  Boolean $enable_http_ssl_redirect = true,
) {
  $snippets_dir = '/etc/nginx/snippets'

  file { '/var/nginx':
    ensure => 'directory',
    group  => 'root',
    mode   => '0644',
  }

  class { '::nginx':
    manage_repo               => false,
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
    server_tokens             => 'off',
    snippets_dir              => $snippets_dir,
    http2                     => 'on',
    gzip                      => 'on',
    gzip_vary                 => 'on',
    gzip_types                => [
      'text/plain',
      'text/css',
      'text/xml',
      'text/javascript',
      'application/x-javascript',
      'application/javascript',
      'application/xml',
    ],
    http_raw_append           => [
      'resolver_timeout 10s;',
      "include ${snippets_dir}/anonymized_log_format.conf;",
    ],
    client_body_temp_path     => '/var/nginx/client_body_temp',
    proxy_temp_path           => '/var/nginx/proxy_temp',
    require                   => File['/var/nginx'],
  }

  # Workaround for `apt update` error:
  # Skipping acquire of configured file 'nginx/binary-i386/Packages' as repository
  # 'https://nginx.org/packages/ubuntu bionic InRelease' doesn't support architecture 'i386'
  $distro = downcase($facts['os']['name'])
  apt::source { 'nginx':
    location     => "https://nginx.org/packages/${distro}",
    repos        => 'nginx',
    architecture => 'amd64',
    key          => { 'id' => '573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62' },
  }

  file { '/etc/nginx/dhparam.pem':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $dhparam,
    notify  => Service['nginx'],
  }

  $snippet_anonymzed_log_format = @(SNIPPET)
map $remote_addr $remote_addr_anon {
  ~(?P<ip>\d+\.\d+\.\d+)\.    $ip.0;
  ~(?P<ip>[^:]+:[^:]+):       $ip::;
  default                     0.0.0.0;
}

log_format anonymized '$remote_addr_anon - $remote_user [$time_local] '
   '"$request" $status $body_bytes_sent '
   '"$http_referer" "$http_user_agent"';
| SNIPPET

  nginx::resource::snippet { 'anonymized_log_format':
    raw_content => $snippet_anonymzed_log_format,
  }

  $snippet_asset_defaults = @(SNIPPET)
location = /favicon.ico {
  access_log off;
  log_not_found off;
}

location ~ /\. {
  access_log off;
  log_not_found off;
  deny all;
}

location ~ ~$ {
  access_log off;
  log_not_found off;
  deny all;
}
| SNIPPET

  nginx::resource::snippet { 'asset_defaults':
    raw_content => $snippet_asset_defaults,
  }

  if $enable_default_site {
    nginx::resource::server { 'default-site':
      server_name    => [
        '_',
      ],
      ipv6_enable    => true,
      listen_port    => 443,
      listen_options => 'default_server',
      format_log     => 'anonymized',
      www_root       => '/srv/www',
      ssl            => true,
      ssl_cert       => '/etc/ssl/certs/gernox_de.crt',
      ssl_key        => '/etc/ssl/private/gernox_de.key',
      include_files  => [
        '/etc/nginx/snippets/asset_defaults.conf',
      ],
    }
  }

  if $enable_http_ssl_redirect {
    nginx::resource::server { 'http-ssl-redirect':
      server_name         => [
        '_',
      ],
      ipv6_enable         => true,
      listen_port         => 80,
      listen_options      => 'default_server',
      access_log          => 'absent',
      error_log           => 'absent',
      index_files         => [],
      location_cfg_append => {
        rewrite => '^ https://$host$request_uri permanent',
      },
    }
  }

  create_resources('nginx::resource::server', $servers)
}
