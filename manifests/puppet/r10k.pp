class profile::puppet::r10k (
) {
  class { 'r10k':
    sources => {
      'control' => {
        'remote'  => 'ssh://git@github.com:gernox/puppet-control.git',
        'basedir' => "${::settings::confdir}/environments",
        'prefix'  => false,
      },
    },
  }

  class { 'r10k::webhook::config':
    default_branch  => 'master',
    enable_ssl      => true,
    protected       => true,
    use_mcollective => false,
    notify          => Service['webhook'],
  }

  class { 'r10k::webhook':
    use_mcollective => false,
    user            => 'root',
    group           => 'root',
    require         => Class['r10k::webhook::config'],
  }
}
