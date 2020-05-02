# @summary
#   Configures fail2ban
#
class profile::hardening::fail2ban {
  $conf_dir = '/etc/fail2ban/jail.d'

  package { 'fail2ban':
    ensure => 'present',
  }

  service { 'fail2ban':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['fail2ban'],
  }

  file { $conf_dir:
    ensure  => directory,
    purge   => true,
    require => Package['fail2ban'],
  }

  file { "${conf_dir}/sshd.conf":
    ensure  => present,
    content => file('profile/hardening/fail2ban/sshd.conf'),
    notify  => Service['fail2ban'],
  }
}
