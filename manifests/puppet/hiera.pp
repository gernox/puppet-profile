class profile::puppet::hiera {

  class { 'hiera':
    hiera_version        => '5',
    hiera5_defaults      => {
      datadir   => 'data',
      data_hash => 'yaml_data',
    },
    hierarchy            => [],
    eyaml                => true,
    manage_eyaml_package => true,
    merge_behavior       => 'deeper',
    provider             => 'puppetserver_gem',
  }

}
