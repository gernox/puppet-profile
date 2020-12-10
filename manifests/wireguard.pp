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

  String $allowed_ips      = "${profile::internal_ip}/32",
  String $fqdn             = $profile::fqdn,
  String $internal_ip      = $profile::internal_ip,
  String $primary_ip       = $profile::primary_ip,

  Optional[String] $parent = undef,
) {

  # Ignore puppetdb during bootstrap
  $peers = $::settings::storeconfigs ? {
    true    => puppetdb_query(
      "resources { type = 'Class' and title = 'Profile::Wireguard' and certname != '${fqdn}' }"
    ),
    default => []
  }

  $wireguard_peers = $peers.map |$peer| {
    {
      'PublicKey'           => $peer['parameters']['public_key'],
      'AllowedIPs'          => $peer['parameters']['allowed_ips'],
      'Endpoint'            => "${peer['parameters']['primary_ip']}:51820",
      'PersistentKeepalive' => 25,
    }
  }

  wireguard::interface { 'wg0':
    ensure      => present,
    private_key => $private_key,
    listen_port => 51820,
    address     => $internal_ip,
    saveconfig  => false,
    peers       => $wireguard_peers,
  }

  class { '::wireguard':
    interfaces => $interfaces,
    require    => Profile::Package['linux-headers-generic'],
  }

  apt::ppa { 'ppa:wireguard/wireguard':
    ensure => absent,
  }

  firewall { '110 IPv4 allow Wireguard access':
    dport  => '51820',
    proto  => 'udp',
    action => 'accept',
  }
}
