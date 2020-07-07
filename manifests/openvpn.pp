# @summary
#   Manages the OpenVPN server configuration
#
class profile::openvpn (
  String $network,

  String $cipher,
  String $tls_cipher,
  String $config_dir,

  String $user,

  String $country,
  String $province,
  String $city,
  String $organization,
  String $email,

  Array $dhcp_options            = [],
  Array $push_options            = [],
  Optional[String] $network_ipv6 = '',
  Optional[Array] $routes        = [],
  Optional[Array] $routes_ipv6   = [],
  Optional[Hash] $options        = {},
  Optional[Hash] $clients        = {},
  Optional[Hash] $client_conf    = {},
  Optional[Hash] $revokes        = {},
) {
  user { $user:
    system     => true,
    shell      => '/usr/sbin/nologin',
    managehome => false,
  }

  class { '::openvpn':
    autostart_all                   => true,
    manage_service                  => true,

    client_defaults                 => {
      server         => 'gernox_internal',
      remote_host    => 'vpn.gernox.de',
      cipher         => $cipher,
      tls_cipher     => $tls_cipher,
      tls_auth       => true,
      custom_options => {
        auth            => 'SHA512',
        key-direction   => '1',
        script-security => '2',
        down-pre        => '',
      },
    },
    clients                         => $clients,
    client_specific_config_defaults => {
      ensure       => present,
      server       => 'openvpn_server',
      dhcp_options => $dhcp_options,
    },
    revokes                         => $revokes,
    revoke_defaults                 => {
      server => 'gernox_internal',
    },
    client_specific_configs         => $client_conf,

    server_defaults                 => {
      local          => '',
      proto          => 'tcp',
      c2c            => true,
      country        => $country,
      province       => $province,
      city           => $city,
      organization   => $organization,
      email          => $email,
      user           => $user,
      group          => $user,
      persist_key    => true,
      persist_tun    => true,
      cipher         => $cipher,
      tls_cipher     => $tls_cipher,
      tls_auth       => true,
      keepalive      => '10 60',
      custom_options => $options,
    },
    servers                         => {
      gernox_internal => {
        topology       => 'subnet',
        server         => $network,
        server_ipv6    => $network_ipv6,
        route          => $routes,
        route_ipv6     => $routes_ipv6,
        push           => $push_options,
        crl_auto_renew => true,
      },
    },
  }
}
