# @summary
#   Manages Nextcloud
#
class profile::nextcloud (
  String $version,
  Stdlib::HTTPUrl $archive_url,
  String $data_dir,
  String $system_user,
  String $system_group,
  String[1] $db_password,
  String $db_name,
  String $db_user,
  Stdlib::Host $db_host,
  Integer $db_port,
  String[1] $admin_login,
  String[1] $admin_password,
  String $fqdn = $profile::fqdn,
) {

  $_app_dir = '/var/www'
  $_default_config = {
    'dbhost'          => $db_host,
    'dbname'          => $db_name,
    'dbuser'          => $db_user,
    'dbpassword'      => $db_password,
    'datadirectory'   => $data_dir,
    'trusted_domains' => ['localhost', $fqdn],
  }
  $_real_config = $_default_config

  profile::tools::create_dir { [ $_app_dir, $_real_config['datadirectory'] ]:
    owner => $system_user,
    group => $system_group,
    mode  => '0700',
  }

  archive { "nextcloud-${version}":
    path         => "/tmp/nextcloud-${version}.zip",
    source       => "${archive_url}/nextcloud-${version}.zip",
    extract      => true,
    extract_path => $_app_dir,
    creates      => "${_app_dir}/nextcloud/index.php",
    cleanup      => true,
    user         => $system_user,
    group        => $system_group,
    require      => [
      Profile::Tools::Create_dir[$_app_dir],
      Profile::Tools::Create_dir[$data_dir],
    ],
  }

  -> file { "${_app_dir}/nextcloud/config/autoconfig.php":
    ensure  => present,
    owner   => $system_user,
    group   => $system_group,
    mode    => '0700',
    content => template('profile/nextcloud/config/autoconfig.php.erb'),
  }

  -> file { "${_app_dir}/nextcloud/config/cache.config.php":
    ensure  => present,
    owner   => $system_user,
    group   => $system_group,
    mode    => '0640',
    content => template('profile/nextcloud/config/cache.config.php.erb'),
  }
  -> file { "${_app_dir}/nextcloud/config/email.config.php":
    ensure  => present,
    owner   => $system_user,
    group   => $system_group,
    mode    => '0640',
    content => template('profile/nextcloud/config/email.config.php.erb'),
  }
  -> file { "${_app_dir}/nextcloud/config/user.config.php":
    ensure  => present,
    owner   => $system_user,
    group   => $system_group,
    mode    => '0640',
    content => template('profile/nextcloud/config/user.config.php.erb'),
  }

  file { '/etc/systemd/system/nextcloud-cron.service':
    ensure  => present,
    content => template('profile/nextcloud/nextcloud-cron.service.erb'),
    notify  => Service['nextcloud-cron'],
  }

  file { '/etc/systemd/system/nextcloud-cron.timer':
    ensure  => present,
    content => template('profile/nextcloud/nextcloud-cron.timer.erb'),
    notify  => Service['nextcloud-cron'],
  }

  service { 'nextcloud-cron':
    ensure  => running,
    enable  => true,
    name    => 'nextcloud-cron.timer',
    require => [
      File['/etc/systemd/system/nextcloud-cron.timer'],
      File['/etc/systemd/system/nextcloud-cron.service'],
    ],
  }

}
