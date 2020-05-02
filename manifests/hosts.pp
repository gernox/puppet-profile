# @summary
#   Manages /etc/hosts configuration
#
# @param hosts
#
# @param location
#
class profile::hosts (

  String $fqdn     = $::fqdn,
  String $hostname = $::hostname,
  String $ip       = fact('networking.ip'),
  Hash $hosts      = {},
) {

  host { $fqdn:
    ip           => $ip,
    host_aliases => $hostname,
  }

  $hosts.each |$k, $v| {
    host { $k:
      * => $v,
    }
  }
}
