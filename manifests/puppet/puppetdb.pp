class profile::puppet::puppetdb (
  String $node_ttl,
  String $node_purge_ttl,
  String $report_ttl,
  String $max_mem,
  String $initial_mem,
) {
  $database_name = 'puppetdb'

  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    node_ttl        => $node_ttl,
    node_purge_ttl  => $node_purge_ttl,
    report_ttl      => $report_ttl,
    java_args       => {
      '-Xmx' => $max_mem,
      '-Xms' => $initial_mem,
    },
    manage_dbserver => false,
    database_name   => $database_name,
  }

  contain profile::postgresql

  # get the pg contrib to use pg_trgm extension
  # class { '::postgresql::server::contrib': }

  postgresql::server::extension { 'pg_trgm':
    database => $database_name,
    require  => Postgresql::Server::Db[$database_name],
  }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }

}
