# @summary
#   Manages the OpenSSH server
#
# @param ssh_options
#
class profile::ssh::client (
  Hash $ssh_options,
) {
  class { '::ssh::client':
    storeconfigs_enabled => false,
    options              => $ssh_options,
  }
}
