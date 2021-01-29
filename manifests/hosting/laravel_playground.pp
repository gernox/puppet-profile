# @summary
#   Manages the laravel playground application
#
class profile::hosting::laravel_playground {
  contain ::gernox_docker

  docker_compose { 'laravel_playground':
    ensure        => present,
    compose_files => ['/tmp/docker-compose.yaml'],
    options       => ['--env-file /tmp/docker-compose.env'],
  }
}
