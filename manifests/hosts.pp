# @summary
#   Manages /etc/hosts configuration
#
# @param hosts
#
# @param location
#
class profile::hosts (
  String $fqdn     = $profile::fqdn,
  String $hostname = $profile::hostname,
  String $ip       = $profile::primary_ip,
  Hash $hosts      = $profile::hosts,
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
