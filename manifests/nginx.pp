# @summary
#   Manages nginx configuration
#
class profile::nginx (
) {
  class { '::nginx':
  }
}
