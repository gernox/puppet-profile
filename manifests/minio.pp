# @summary
#   Manages minio
#
#
class profile::minio (
  String $version,
  String $network_name,
  String $bridge_name,
  String $http_domain,
  Integer $http_port,
  String $browser,
  String $secret_key,
  String $access_key,
  String $base_dir      = $profile::base_dir,
  Boolean $manage_nginx = false,
) {
  contain ::gernox_docker

  $minio_base_dir = "${base_dir}/data/minio"
  $minio_conf_dir = "${minio_base_dir}/conf"
  $minio_data_dir = "${minio_base_dir}/data"

  profile::tools::create_dir { $minio_base_dir:
  }
  -> profile::tools::create_dir { $minio_conf_dir:
  }
  -> profile::tools::create_dir { $minio_data_dir:
  }

  ::docker::image { 'minio':
    ensure    => present,
    image     => 'minio/minio',
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

  ::docker::run { 'minio':
    image                 => "minio/minio:${version}",
    health_check_interval => 30,
    ports                 => [
      "127.0.0.1:${http_port}:9000",
    ],
    env                   => [
      "MINIO_BROWSER=${browser}",
      "MINIO_SECRET_KEY=${secret_key}",
      "MINIO_ACCESS_KEY=${access_key}",
    ],
    volumes               => [
      "${minio_data_dir}:/data",
      "${minio_conf_dir}:/root/.minio",
    ],
    command               => 'server /data',
    net                   => $network_name,
    require               => [
      Profile::Tools::Create_dir[$minio_conf_dir],
      Profile::Tools::Create_dir[$minio_data_dir],
    ],
  }

  if $manage_nginx {
    contain ::profile::minio::nginx
  }

}
