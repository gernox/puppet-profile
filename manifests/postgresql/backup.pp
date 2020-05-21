# @summary
#   Manages the PostgreSQL backups
#
# @param password
#
# @param base_dir
#
class profile::postgresql::backup (
  String $backup_time,
  String $password = $profile::postgresql::password,
  String $base_dir = $profile::base_dir,
) {
  $backup_dir = "${base_dir}/backups/postgresql"

  file { '/home/postgres/.pgpass':
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0600',
    content => "localhost:5432:*:postgres:${password}",
    require => Class['postgresql::server'],
  }

  file { $backup_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'postgres',
    mode    => '0770',
    require => Class['postgresql::server'],
  }
  -> file { "${backup_dir}/pg_backup.sh":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/profile/postgresql/pg_backup.sh',
  }
  -> file { "${backup_dir}/pg_backup_rotated.sh":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/profile/postgresql/pg_backup_rotated.sh',
  }
  -> file { "${backup_dir}/pg_backup.config":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profile/postgresql/pg_backup.config.erb'),
  }

  # Systemd service and timer
  file { '/etc/systemd/system/pg_backup.service':
    ensure  => present,
    content => template('profile/postgresql/pg_backup.service.erb'),
    notify  => Service['pg_backup'],
  }

  file { '/etc/systemd/system/pg_backup.timer':
    ensure  => present,
    content => template('profile/postgresql/pg_backup.timer.erb'),
    notify  => Service['pg_backup'],
  }

  service { 'pg_backup':
    ensure  => running,
    enable  => true,
    name    => 'pg_backup.timer',
    require => [
      File["${backup_dir}/pg_backup.sh"],
      File['/etc/systemd/system/pg_backup.service'],
      File['/etc/systemd/system/pg_backup.timer'],
    ],
  }
}
