# @summary
#   Manages the nginx configuration for hosting blog
#
# @param http_domain
#
# @param s3_bucket
#
class profile::hosting::blog (
  String $s3_bucket,
) {
  contain profile::nginx

  nginx::resource::server { 'haase-dev-redirect':
    server_name         => [
      'haase.dev',
    ],
    listen_port         => 443,
    ssl                 => true,
    ssl_cert            => '/etc/ssl/certs/haase_dev.crt',
    ssl_key             => '/etc/ssl/private/haase_dev.key',
    access_log          => 'absent',
    error_log           => 'absent',
    index_files         => [],
    location_cfg_append => {
      rewrite => '^ https://blog.haase.dev permanent',
    },
  }

  nginx::resource::server { 'blog-haase-dev':
    server_name         => [
      'blog.haase.dev',
    ],
    http2               => 'on',
    listen_port         => 443,
    format_log          => 'anonymized',
    ssl                 => true,
    ssl_cert            => '/etc/ssl/certs/haase_dev.crt',
    ssl_key             => '/etc/ssl/private/haase_dev.key',
    proxy               => "https://s3.gernox.de",
    error_pages         => {
      404 => '@404',
    },
    location_cfg_append => {
      rewrite => [
        "^/?$ /${s3_bucket}/index.html break",
        "^/([a-zA-Z/-]+[^/])/?$ /${s3_bucket}/\$1/index.html break",
        "/(.*) /${s3_bucket}/\$1 break",
      ],
    },
    location_raw_append => [
      'proxy_ssl_server_name on;',
      'proxy_intercept_errors on;',
      'proxy_ignore_headers Set-Cookie;',
    ],
    raw_prepend         => [
      'location @404 {',
      '  return 302 /404.html;',
      '}',
    ],
    proxy_hide_header   => [
      'x-amz-id-2',
      'x-amz-meta-etag',
      'x-amz-request-id',
      'x-amz-meta-server-side-encryption',
      'x-amz-server-side-encryption',
      'Set-Cookie',
    ],
    proxy_set_header    => [
      'Host s3.gernox.de',
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'X-Forwarded-Proto $scheme',
    ],
  }
}
