# @summary
#   Manages gitea
#
#
class profile::gitea (
  String $version,
  String $db_host,
  Integer $db_port,
  String $db_user,
  String $db_password,
  String $db_name,
  String $network_name,
  String $bridge_name,
  Integer $http_port,
  Integer $ssh_port,
  String $user,
  String $group,
  String $mail_host,
  Integer $mail_port,
  String $mail_user,
  String $mail_password,
  String $log_level,
  String $secret_key,
  String $internal_token,
  String $jwt_secret,
  String $base_dir      = $profile::base_dir,
  Boolean $manage_nginx = false,
) {
  contain ::gernox_docker
  contain ::profile::postgresql

  $gitea_base_dir = "${base_dir}/data/gitea"
  $gitea_conf_dir = "${gitea_base_dir}/custom/conf"
  $gitea_backup_dir = "${gitea_base_dir}/backup"

  profile::tools::create_dir { $gitea_base_dir:
    owner => $user,
    group => $group,
  }
  -> profile::tools::create_dir { $gitea_conf_dir:
    owner => $user,
    group => $group,
  }
  -> profile::tools::create_dir { $gitea_backup_dir:
    owner => $user,
    group => $group,
  }

  file { "${gitea_conf_dir}/app.ini":
    ensure  => present,
    content => template('profile/gitea.ini.erb'),
    owner   => $user,
    group   => $group,
    require => Profile::Tools::Create_dir[$gitea_conf_dir],
    notify  => Docker::Run['gitea'],
  }

  profile::postgresql::db { $db_name:
    user     => $db_user,
    password => $db_password,
  }

  ::docker::image { 'gitea':
    ensure    => present,
    image     => 'gitea/gitea',
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

  ::docker::run { 'gitea':
    image                 => "gitea/gitea:${version}",
    health_check_interval => 30,
    ports                 => [
      "127.0.0.1:${http_port}:3000",
      "${ssh_port}:22",
    ],
    env                   => [
      'GITEA_WORK_DIR=/data',
      'GITEA_CUSTOM=/data/custom',
      'USER=git',
      'HOME=/data/home',

    ],
    volumes               => [
      "${gitea_base_dir}:/data",
      '/etc/timezone:/etc/timezone:ro',
      '/etc/localtime:/etc/localtime:ro',
    ],
    net                   => $network_name,
    require               => File["${gitea_conf_dir}/app.ini"],
  }

  if $manage_nginx {
    contain ::profile::gitea::nginx
  }

  # Job for backup
  file { '/etc/systemd/system/gitea-backup.service':
    ensure  => present,
    content => template('profile/gitea/gitea-backup.service.erb'),
    notify  => Service['gitea-backup'],
  }

  file { '/etc/systemd/system/gitea-backup.timer':
    ensure  => present,
    content => template('profile/gitea/gitea-backup.timer.erb'),
    notify  => Service['gitea-backup'],
  }

  service { 'gitea-backup':
    ensure   => running,
    enable   => true,
    name     => 'gitea-backup.timer',
    provider => 'systemd',
    require  => [
      File['/etc/systemd/system/gitea-backup.timer'],
      File['/etc/systemd/system/gitea-backup.service'],
    ],
  }

}
