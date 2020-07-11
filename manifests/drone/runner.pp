# @summary
#   Manages drone
#
#
class profile::drone::runner (
  String $version,
  String $rpc_host,
  String $rpc_secret,
  Integer $capacity,
  String $network_name,
  String $bridge_name,
  String $hostname = $profile::hostname,
) {
  contain ::gernox_docker

  ::docker::image { 'drone-runner':
    ensure    => present,
    image     => 'drone/drone-runner-docker',
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
    image                 => "drone/drone-runner-docker:${version}",
    health_check_interval => 30,
    env                   => [
      "DRONE_RPC_PROTO=https",
      "DRONE_RPC_HOST=${rpc_host}",
      "DRONE_RPC_SECRET=${rpc_secret}",
      "DRONE_RUNNER_CAPACITY=${capacity}",
      "DRONE_RUNNER_NAME=${hostname}",
    ],
    volumes               => [
      '/var/run/docker.sock:/var/run/docker.sock',
    ],
    net                   => $network_name,
  }
}
