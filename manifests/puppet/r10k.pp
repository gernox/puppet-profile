class profile::puppet::r10k (
  String $default_branch,
  String $github_secret,
  String $control_repo,
) {
  class { 'r10k':
    sources => {
      'control' => {
        'remote'  => $control_repo,
        'basedir' => "${::settings::codedir}/environments",
        'prefix'  => false,
      },
    },
  }

  class { 'r10k::webhook::config':
    default_branch  => $default_branch,
    enable_ssl      => false,
    protected       => false,
    github_secret   => $github_secret,
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
