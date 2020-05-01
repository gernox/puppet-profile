# @summary
#   Manages firewall rules for IPv4 after all system specific rules are applied
#
class profile::firewall::post_ipv4 {
  firewall { '999 - IPv4: drop all other requests':
    proto  => 'all',
    action => 'drop',
    before => undef,
  }
}
