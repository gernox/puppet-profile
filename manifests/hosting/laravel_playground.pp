# @summary
#   Manages the laravel playground application
#
class profile::hosting::laravel_playground {
  contain ::gernox_docker

  ::docker::stack { 'laravel_playground':
    ensure        => present,
    stack_name    => 'laravel_playground',
    compose_files => ['/tmp/docker-compose.yaml'],
  }
}
