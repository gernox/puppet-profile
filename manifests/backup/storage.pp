# @summary
#   Manages the bareos backup storage
#
class profile::backup::storage (
  Array $devices,
) {
  class { '::gernox_bareos::storage':
    devices => $devices,
  }
}
