# @summary
#   Manages firewall rules for IPv6 after all system specific rules are applied
#
class profile::firewall::post_ipv6 {
  firewall { '999 - IPv6: drop all other requests':
    proto    => 'all',
    action   => 'drop',
    provider => 'ip6tables',
    before   => undef,
  }
}
