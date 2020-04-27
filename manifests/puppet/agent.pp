class profile::puppet::agent (
  String $puppet_collection,
  String $puppet_version,
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

}
