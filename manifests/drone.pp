# @summary
#   Manages drone
#
#
class profile::drone (
  String $version,
  String $db_host,
  Integer $db_port,
  String $db_user,
  String $db_password,
  String $db_name,
  String $network_name,
  String $bridge_name,
  String $http_domain,
  Integer $http_port,
  String $gitea_server,
  String $gitea_client_id,
  String $gitea_client_secret,
  String $rpc_secret,
  String $base_dir      = $profile::base_dir,
  Boolean $manage_nginx = false,
) {
  contain ::gernox_docker
  contain ::profile::postgresql

  $drone_base_dir = "${base_dir}/data/drone"

  profile::tools::create_dir { $drone_base_dir:
  }

  profile::postgresql::db { $db_name:
    user     => $db_user,
    password => $db_password,
  }

  ::docker::image { 'drone':
    ensure    => present,
    image     => 'drone/drone',
    image_tag => $version,
  }

  docker_network { $network_name:
    ensure  => present,
    options => "com.docker.network.bridge.name=${bridge_name}",
  }

  firewall { "002 - IPv4: accept all ${bridge_name}":
    iniface => $bridge_name,
    action  => 'accept',
  }

  ::docker::run { 'drone':
    image                 => "drone/drone:${version}",
    health_check_interval => 30,
    ports                 => [
      "127.0.0.1:${http_port}:80",
    ],
    env                   => [
      "DRONE_GITEA_SERVER=${gitea_server}",
      "DRONE_GITEA_CLIENT_ID=${gitea_client_id}",
      "DRONE_GITEA_CLIENT_SECRET=${gitea_client_secret}",
      "DRONE_RPC_SECRET=${rpc_secret}",
      'DRONE_GIT_ALWAYS_AUTH=true',
      'DRONE_SERVER_PROTO=https',
      "DRONE_SERVER_HOST=${http_domain}",
      'DRONE_DATABASE_DRIVER=postgres',
      "DRONE_DATABASE_DATASOURCE=postgres://${db_user}:${db_password}@${db_host}:${db_port}/${db_name}?sslmode=disable",
    ],
    volumes               => [
      "${drone_base_dir}:/data",
      '/var/run/docker.sock:/var/run/docker.sock',
    ],
    net                   => $network_name,
    require               => Profile::Tools::Create_dir[$drone_base_dir],
  }

  if $manage_nginx {
    contain ::profile::drone::nginx
  }

}
