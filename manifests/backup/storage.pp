# @summary
#   Manages the bareos backup storage
#
class profile::backup::storage (
  Hash $devices,
) {
  class { '::gernox_bareos::storage':
    devices => $devices,
  }
}
