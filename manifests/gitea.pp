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
  Integer $user_uid,
  Integer $user_gid,
  String $mail_host,
  Integer $mail_port,
  String $mail_user,
  String $mail_password,
  String $log_level,
  String $secret_key,
  String $internal_token,
  String $jwt_secret,
  String $base_dir = $profile::base_dir,
) {
  contain ::gernox_docker
  contain ::profile::postgresql

  profile::tools::create_dir { "${base_dir}/data/gitea/custom/conf":
    owner => $user_uid,
    group => $user_gid,
  }

  file { "${base_dir}/data/gitea/custom/conf/app.ini":
    ensure  => present,
    content => template('profile/gitea.ini.erb'),
    owner   => $user_uid,
    group   => $user_gid,
    require => Profile::Tools::Create_dir["${base_dir}/data/gitea/custom/conf"],
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
      "${http_port}:3000",
      "${ssh_port}:22",
    ],
    env                   => [
      "USER_UID=${user_uid}",
      "USER_GID=${user_gid}",
      'GITEA_WORK_DIR=/data',
      'GITEA_CUSTOM=/data/custom',
      'USER=git',
      'HOME=/data/home',

    ],
    volumes               => [
      "${base_dir}/data/gitea:/data",
      '/etc/timezone:/etc/timezone:ro',
      '/etc/localtime:/etc/localtime:ro',
    ],
    net                   => $network_name,
    require               => File["${base_dir}/data/gitea/custom/conf/app.ini"],
  }

}
