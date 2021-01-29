# @summary
#   Manages the laravel playground application
#
class profile::hosting::laravel_playground {
  contain ::gernox_docker

  $base_dir = "/tmp"

  file { "${base_dir}/.env":
    content => "TAG=14.04",
  }

  docker_compose { 'laravel_playground':
    ensure        => present,
    compose_files => ["${base_dir}/docker-compose.yaml"],
    require       => File["${base_dir}/.env"]
  }
}
