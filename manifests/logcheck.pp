# @summary
#   Manages logcheck
#
class profile::logcheck {
  package { 'logcheck':
    ensure => present,
  }

  file { '/etc/logcheck/ignore.d.server':
    ensure  => directory,
    owner   => 'root',
    group   => 'logcheck',
    mode    => '0644',
    purge   => false,
    recurse => true,
    source  => 'puppet:///modules/profile/logcheck/ignore.d.server',
    require => Package['logcheck'],
  }

  file { '/etc/logcheck/violations.ignore.d':
    ensure  => directory,
    owner   => 'root',
    group   => 'logcheck',
    mode    => '0644',
    purge   => true,
    recurse => true,
    source  => 'puppet:///modules/profile/logcheck/violations.ignore.d',
    require => Package['logcheck'],
  }
}
