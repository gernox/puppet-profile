class profile::puppet::agent (
  String $puppet_collection,
  String $puppet_version,
  String $puppet_server,
  String $run_interval,
) {

  class { 'puppet_agent':
    collection      => $puppet_collection,
    package_version => $puppet_version,
    is_pe           => false,
    manage_repo     => true,
  }

  file { "/etc/apt/sources.list.d/${puppet_collection}.list":
    ensure => absent,
  }

  ini_setting { 'puppet agent server':
    ensure  => present,
    path    => $settings::config,
    section => 'main',
    setting => 'server',
    value   => $puppet_server,
  }

  ini_setting { 'puppet agent strict variable checking':
    ensure  => present,
    path    => $settings::config,
    section => 'main',
    setting => 'strict_variables',
    value   => true,
  }

  ini_setting { 'puppet agent runinterval':
    ensure  => present,
    path    => $settings::config,
    section => 'main',
    setting => 'runinterval',
    value   => $run_interval,
  }

  file { '/etc/logrotate.d/puppet-agent':
    ensure  => present,
    content => file('profile/puppet/puppet-agent-logrotate'),
  }

  # We are not using PCP eXecution protocol (PXP)
  service { 'pxp-agent':
    enable => false,
  }

  file { '/etc/logrotate.d/pxp-agent':
    ensure => absent,
  }

}
