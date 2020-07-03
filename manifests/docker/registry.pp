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
) {
  contain ::gernox_docker

  $network_name = 'registry-network'
  $bridge_name = 'br-registry'

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
      "${port}:5000",
    ],
    net                   => $network_name,
  }
}
