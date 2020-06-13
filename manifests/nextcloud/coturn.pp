# @summary
#   Manages the coturn server
#
class profile::nextcloud::coturn (
  String $secret,
  String $domain,
  Integer $port,
) {
  package { 'coturn':
    ensure => present,
  }

  file { '/etc/turnserver.conf':
    ensure  => present,
    content => template('profile/nextcloud/turnserver.conf.erb'),
    require => Package['coturn'],
  }

  service { 'coturn':
    ensure  => running,
    require => Package['coturn'],
  }

  firewall { '100 IPv4 allow coTURN TCP traffic':
    dport  => $port,
    proto  => tcp,
    action => accept,
  }

  firewall { '100 IPv4 allow coTURN UDP traffic':
    dport  => $port,
    proto  => udp,
    action => accept,
  }

  firewall { '100 IPv6 allow coTURN TCP traffic':
    dport    => $port,
    proto    => tcp,
    action   => accept,
    provider => 'ip6tables',
  }

  firewall { '100 IPv6 allow coTURN UDP traffic':
    dport    => $port,
    proto    => udp,
    action   => accept,
    provider => 'ip6tables',
  }
}
