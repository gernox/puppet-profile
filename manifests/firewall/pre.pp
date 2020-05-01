# @summary
#   Manages the basic firewall configuration for IPv4, before system specific rules are applied
#
# @param forward_policy
#   Policy for forwarding table
#
# @param ignore_rules
#   List of rules to ignore when purging
#
class profile::firewall::pre {
  Firewall {
    require => undef,
  }

  contain profile::firewall::pre_ipv4
  contain profile::firewall::pre_ipv6

  firewall { '100 - IPv4: allow ssh access':
    dport  => 22,
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '100 - IPv6: allow ssh access':
    dport    => 22,
    proto    => 'tcp',
    action   => 'accept',
    provider => 'ip6tables',
  }
}
