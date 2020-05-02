# @summary
#   Manages rsyslog
#
# @param conf_filepath
#
class profile::logs::rsyslog (
  String $conf_filepath = '/etc/rsyslog.conf',
) {
  package { 'rsyslog':
    ensure => installed,
  }

  service { 'rsyslog':
    hasrestart => true,
    require    => Package['rsyslog'],
  }

  file { $conf_filepath:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/profile/logs/rsyslog/rsyslog.conf',
    notify => Service['rsyslog'],
  }
}
