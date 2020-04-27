class profile::puppet::master (

) {

  contain profile::puppet::puppetdb
  contain profile::puppet::r10k

}
