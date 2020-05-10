# @summary
#   Manages the wireguard configuration
#
# @param interfaces
#   Interface configurations
#
class profile::wireguard (
  String $public_key,
  String $private_key,
  Hash $interfaces,

  String $fqdn        = $profile::fqdn,
  String $internal_ip = $profile::internal_ip,
  String $primary_ip  = $profile::primary_ip,
) {

  @@profile::wireguard_peer { "peer_${fqdn}":
    ensure      => present,
    internal_ip => $internal_ip,
    external_ip => $primary_ip,
    public_key  => $public_key,
  }

  Profile::Wireguard_peer <<| name != "peer_${fqdn}" |>>

  class { '::wireguard':
    interfaces => $interfaces,
    require    => Profile::Package['linux-headers-generic'],
  }
}
