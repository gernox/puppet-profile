class profile::puppet::master (
  Integer $purge_report_days,
  Hash $nodes,
) {

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

  file { '/etc/cron.d/puppetserver-purge-reports':
    ensure  => present,
    content => "# Warning: This file is managed by puppet;
31 1 * * root /usr/bin/find /opt/puppetlabs/server/data/puppetserver/reports/ -mtime ${purge_report_days} -type f -delete
",
    mode    => '0740',
  }

  $nodes.each |$host, $ip| {
    firewall { "110 IPv4 allow Puppetserver access for ${host} from ${ip}":
      source => $ip,
      dport  => 8140,
      proto  => 'tcp',
      action => 'accept',
    }
  }

}
