class profile::puppet::master (

) {

  contain profile::puppet::agent
  contain profile::puppet::hiera
  contain profile::puppet::puppetdb
  contain profile::puppet::r10k

}
