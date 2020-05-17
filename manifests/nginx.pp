# @summary
#   Manages nginx configuration
#
# @param servers
#
class profile::nginx (
  String $dhparam,
  Hash $servers = {},
) {
  $snippets_dir = '/etc/nginx/snippets'

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
    snippets_dir              => $snippets_dir,
    http_format_log           => 'anonymized',
    http_raw_append           => [
      'resolver_timeout 10s;',
      "include ${snippets_dir}/anonymized_log_format.conf;",
    ]
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

  create_resources('nginx::resource::server', $servers)
}
