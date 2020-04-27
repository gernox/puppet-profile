class profile::puppet::master (

) {

  contain profile::puppet::agent
  contain profile::puppet::hiera
  contain profile::puppet::puppetdb
  contain profile::puppet::r10k

  ini_setting { 'puppetserver autosign':
    ensure  => present,
    path    => $settings::config,
    section => 'master',
    setting => 'autosign',
    value   => false,
    notify  => Service['puppetserver'],
  }

}
