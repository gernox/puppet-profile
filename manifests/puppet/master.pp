class profile::puppet::master (

) {

  contain profile::puppet::hiera
  contain profile::puppet::puppetdb
  contain profile::puppet::r10k

}
