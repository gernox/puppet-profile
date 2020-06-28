# @summary
#   Manages Keycloak
#
class profile::keycloak (
  Integer $http_port,
  String $http_domain,
  String $admin_password,
  String $db_password,
  String $keycloak_version,
  Boolean $manage_nginx = false,
) {

  class { '::gernox_keycloak':
    http_port          => $http_port,
    base_url           => "https://${http_domain}/auth",
    admin_password     => $admin_password,
    db_password        => $db_password,
    keycloak_version   => $keycloak_version,
  }

  if $manage_nginx {
    contain profile::nginx

    nginx::resource::server { 'keycloak':
      server_name      => [
        $http_domain,
      ],
      listen_port      => 443,
      format_log       => 'anonymized',
      proxy            => "http://localhost:${http_port}/",
      proxy_set_header => [
        'Host $host',
        'X-Real-IP $remote_addr',
        'X-Forwarded-For $proxy_add_x_forwarded_for',
        'X-Forwarded-Proto $scheme',
      ],
      ssl              => true,
      ssl_cert         => '/etc/ssl/certs/gernox_de.crt',
      ssl_key          => '/etc/ssl/private/gernox_de.key',
    }
  }


}
