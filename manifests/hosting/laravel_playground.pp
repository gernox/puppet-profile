# @summary
#   Manages the laravel playground application
#
class profile::hosting::laravel_playground {
  contain ::gernox_docker

  docker_compose { 'laravel_playground':
    ensure        => present,
    compose_files => ['/tmp/docker-compose.yaml'],
    up_args       => '--env-file /tmp/docker-compose.env',
  }
}
