# @summary
#   Manages a docker registry
#
# @param version
#
# @param port
#
class profile::docker::registry (
  String $version,
  Integer $port,
  Boolean $manage_nginx = false,
  String $base_dir      = $profile::base_dir,
) {
  contain ::gernox_docker

  $registry_base_dir = "${base_dir}/data/registry"

  $network_name = 'registry-network'
  $bridge_name = 'br-registry'

  profile::tools::create_dir { $registry_base_dir:
  }

  ::docker::image { 'registry':
    ensure    => present,
    image     => 'registry',
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

  ::docker::run { 'registry':
    image                 => "registry:${version}",
    health_check_interval => 30,
    ports                 => [
      "127.0.0.1:${port}:5000",
    ],
    volumes               => [
      "${registry_base_dir}:/var/lib/registry",
    ],
    net                   => $network_name,
    require               => Profile::Tools::Create_dir[$registry_base_dir],
  }

  if $manage_nginx {
    contain ::profile::docker::registry::nginx
  }
}
