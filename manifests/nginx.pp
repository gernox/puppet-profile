# @summary
#   Manages nginx configuration
#
class profile::nginx (
) {
  class { '::nginx':
    confd_purge  => true,
    server_purge => true,
  }
}
