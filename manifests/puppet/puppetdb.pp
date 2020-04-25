class profile::puppet::puppetdb (
  String $node_ttl,
  String $node_purge_ttl,
  String $report_ttl,
  String $max_mem,
  String $initial_mem,
) {
  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    node_ttl       => $node_ttl,
    node_purge_ttl => $node_purge_ttl,
    report_ttl     => $report_ttl,
    java_args      => {
      '-Xmx' => $max_mem,
      '-Xms' => $initial_mem,
    }
  }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }

}
