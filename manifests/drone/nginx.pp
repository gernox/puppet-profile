# @summary
#   Manages the nginx configuration for drone
#
# @param http_domain
#
# @param http_port
#
class profile::drone::nginx (
  String $http_domain = $profile::drone::nginx::http_domain,
  Integer $http_port  = $profile::drone::http_port,
) {
  contain profile::nginx

  nginx::resource::server { 'drone':
    server_name      => [
      $http_domain,
    ],
    listen_port      => 443,
    format_log       => 'anonymized',
    ssl              => true,
    ssl_cert         => '/etc/ssl/certs/gernox_de.crt',
    ssl_key          => '/etc/ssl/private/gernox_de.key',
    proxy            => "http://localhost:${http_port}",
    proxy_set_header => [
      'Host $http_host',
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'X-Forwarded-Proto $scheme',
    ],
  }
}
