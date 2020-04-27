class profile::puppet::agent {

  class { 'puppet_agent':
    collection      => 'puppet6',
    package_version => 'auto',
    is_pe           => false,
    manage_repo     => true,
  }

}
