class profile::puppet::r10k (
) {
  class { 'r10k':
    sources => {
      'control' => {
        'remote'  => 'https://github.com/gernox/puppet-control.git',
        'basedir' => "${::settings::codedir}/environments",
        'prefix'  => false,
      },
    },
  }

  class { 'r10k::webhook::config':
    default_branch  => 'production',
    enable_ssl      => false,
    protected       => false,
    github_secret   => 'THISISTHEGITHUBWEBHOOKSECRET',
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
