# @summary
#   Manages a wireguard peer configuration
#
# @param ensure
#
# @param internal_ip
#
# @param external_ip
#
# @param public_key
#
# @param ip
#
# @private_key
#
define profile::wireguard_peer (
  String $internal_ip,
  String $external_ip,
  String $public_key,

  Enum['absent', 'present'] $ensure = present,
  String $ip                        = $profile::wireguard::internal_ip,
  String $private_key               = $profile::wireguard::private_key,
) {
  wireguard::interface { $name:
    ensure      => $ensure,
    private_key => $private_key,
    listen_port => 51820,
    address     => $ip,
    saveconfig  => false,
    peers       => [
      {
        'PublicKey'           => $public_key,
        'AllowedIPs'          => "${internal_ip}/32",
        'Endpoint'            => "${external_ip}:51820",
        'PersistentKeepalive' => 25,
      }
    ],
  }

}
