# @summary
#   Manages the psad - Port Scan Attack Detector
#
# @param notification_mail
#   Email address to which psad should send scan alerts and status emails
#
# @param hostname
#   Hostname of the node
#
# @param auto_dl
#   List of Ips to add to auto_dl (will get merged)
#
class profile::firewall::psad (
  String $notification_mail,
  String $hostname          = $::fqdn,

  Optional[Array] $auto_dl = [],
) {
  package { 'psad':
    ensure => installed,
  }

  service { 'psad':
    hasrestart => true,
    require    => Package['psad'],
  }

  file { '/etc/psad/psad.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profile/firewall/psad/psad.conf.erb'),
    notify  => Service['psad'],
  }

  file { '/etc/psad/auto_dl':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profile/firewall/psad/auto_dl.erb'),
    notify  => Service['psad'],
  }
}
