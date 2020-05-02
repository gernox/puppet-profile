# @summary
#   Manages SMART
#
class profile::smart {
  package { 'smartmontools':
    ensure => present,
  }

  file { '/usr/local/sbin/smart-test.sh':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0751',
    source => 'puppet:///modules/profile/smart/smart-test.sh',
  }

  contain profile::smart::short
  contain profile::smart::long
}
