# @summary
#   Manages grafana
#
# @param http_port
#
# @param http_domain
#
# @param http_root_url
#
# @param postgresql_version
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
  String $http_root_url,
  String $postgresql_version,
  String $db_user,
  String $db_password,
  String $db_name,
  Integer $db_port,
  String $admin_user,
  String $admin_password,
  String $secret_key,
) {
  contain ::gernox_docker

  if !defined(Docker::Image["postgres:${postgresql_version}"]) {
    ::docker::image { "postgres:${postgresql_version}":
      ensure    => present,
      image     => 'postgres',
      image_tag => $postgresql_version,
    }
  }

  ::docker::run { 'grafana-postgres':
    image                 => "postgres:${postgresql_version}",
    volumes               => [
      '/srv/docker/grafana/postgresql/data:/var/lib/postgresql/data',
    ],
    health_check_interval => 30,
    env                   => [
      "POSTGRES_USER=${db_user}",
      "POSTGRES_PASSWORD=${db_password}",
      "POSTGRES_DB=${db_name}",
    ],
    ports                 => [
      "${db_port}:5432",
    ],
  }

  class { '::grafana':
    cfg => {
      app_mode  => 'production',
      server    => {
        http_port => $http_port,
        domain    => $http_domain,
        root_url  => $http_root_url,
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
}
