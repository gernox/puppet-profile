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
    server_name      => [
      'blog.haase.dev',
    ],
    listen_port      => 443,
    format_log       => 'anonymized',
    ssl              => true,
    ssl_cert         => '/etc/ssl/certs/haase_dev.crt',
    ssl_key          => '/etc/ssl/private/haase_dev.key',
    proxy            => "https://s3.gernox.de/${s3_bucket}/",
    proxy_set_header => [
      'Host $http_host',
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'X-Forwarded-Proto $scheme',
    ],
  }
}
