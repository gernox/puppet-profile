# @summary
#   Manages the OpenSSH client and server configuration
#
# @param configs_hash
#
# @param keygens_hash
#
class profile::ssh (
  Hash $keygens_hash  = {},
  Hash $keyscans_hash = {},
) {

  contain profile::ssh::client
  contain profile::ssh::server

  $keygens_hash.each |$k, $v| {
    profile::ssh::keygen { $k:
      * => $v,
    }
  }

  $keyscans_hash.each |$k, $v| {
    profile::ssh::keyscan { $k:
      * => $v,
    }
  }

}
