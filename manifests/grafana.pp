# @summary
#   Manages grafana
#
# @param http_port
#
# @param http_domain
#
# @param db_user
#
# @param db_password
#
# @param db_name
#
# @param db_port
#
# @param admin_user
#
# @param admin_password
#
# @param secret_key
#
class profile::grafana (
  Integer $http_port,
  String $http_domain,
  String $db_user,
  String $db_password,
  String $db_name,
  Integer $db_port,
  String $admin_user,
  String $admin_password,
  String $secret_key,
  Boolean $manage_nginx = false,
) {
  contain profile::postgresql

  profile::postgresql::db { $db_name:
    user     => $db_user,
    password => $db_password,
  }

  class { '::grafana':
    cfg => {
      app_mode  => 'production',
      server    => {
        http_port => $http_port,
        domain    => $http_domain,
        root_url  => "https://${http_domain}/",
      },
      database  => {
        type     => 'postgres',
        host     => "localhost:${db_port}",
        name     => $db_name,
        user     => $db_user,
        password => $db_password,
      },
      users     => {
        allow_sign_up => false,
      },
      security  => {
        admin_user       => $admin_user,
        admin_password   => $admin_password,
        secret_key       => $secret_key,
        disable_gravatar => true,
      },
      analytics => {
        reporting_enables => false,
      },
    },
  }

  $grafana_url = "http://localhost:${http_port}"

  http_conn_validator { 'grafana-conn-validator':
    host     => 'localhost',
    port     => $http_port,
    use_ssl  => false,
    test_url => '/public/img/grafana_icon.svg',
    require  => Class['grafana'],
  }
  -> grafana_organization { 'gernox':
    id               => 2,
    grafana_url      => $grafana_url,
    grafana_user     => $admin_user,
    grafana_password => $admin_password,
  }
  -> grafana_datasource { 'gernox-prometheus':
    grafana_url      => $grafana_url,
    grafana_user     => $admin_user,
    grafana_password => $admin_password,
    grafana_api_path => '/api',
    type             => 'prometheus',
    organization     => 'gernox',
    url              => 'http://localhost:9090',
    access_mode      => 'proxy',
    is_default       => true,
  }

  if $manage_nginx {
    contain profile::nginx

    nginx::resource::server { 'grafana':
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
      ssl_cert         => '/etc/ssl/certs/gernox_it.crt',
      ssl_key          => '/etc/ssl/private/gernox_it.key',
    }
  }
}
