# @summary
#   Manages the basic firewall configuration for IPv6, before system specific rules are applied
#
# @param forward_policy
#   Policy for forwarding table
#
# @param ignore_rules
#   List of rules to ignore when purging
#
class profile::firewall::pre_ipv6 (
  Enum['accept', 'drop'] $forward_policy = $profile::firewall::forward_policy,
  Array $ignore_rules                    = $profile::firewall::ignore_rules,
) {
  # Default policy for chains
  firewallchain { 'INPUT:filter:IPv6':
    ensure => present,
    purge  => true,
    policy => drop,
    ignore => $ignore_rules,
  }

  firewallchain { 'OUTPUT:filter:IPv6':
    ensure => present,
    purge  => true,
    policy => accept,
    ignore => $ignore_rules,
  }

  firewallchain { 'OUTPUT:nat:IPv6':
    ensure => present,
    purge  => true,
    policy => accept,
    ignore => $ignore_rules,
  }

  firewallchain { 'PREROUTING:nat:IPv6':
    ensure => present,
    purge  => true,
    policy => accept,
    ignore => $ignore_rules,
  }

  firewallchain { 'POSTROUTING:nat:IPv6':
    ensure => present,
    purge  => true,
    policy => accept,
    ignore => $ignore_rules,
  }

  firewallchain { 'FORWARD:filter:IPv6':
    ensure => present,
    purge  => true,
    policy => $forward_policy,
    ignore => $ignore_rules,
  }

  firewallchain { 'LOGGING:filter:IPv6':
    ensure => present,
    purge  => true,
  }

  # Sane Default Rules that are always applied first
  firewall { '000 - IPv6: accept all ICMPv6':
    proto  => 'ipv6-icmp',
    action => 'accept',
  }

  firewall { '001 - IPv6: accept all to lo interface':
    proto    => 'all',
    iniface  => 'lo',
    action   => 'accept',
    provider => 'ip6tables',
  }
  -> firewall { '002 - IPv6: reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '::1/128',
    action      => 'reject',
    provider    => 'ip6tables',
  }
  -> firewall { '003 - IPv6: accept all docker0':
    iniface  => 'docker0',
    action   => 'accept',
    provider => 'ip6tables',
  }
  -> firewall { '004 - IPv6: accept related established rules':
    proto    => 'all',
    state    => ['RELATED', 'ESTABLISHED'],
    action   => 'accept',
    provider => 'ip6tables',
  }
  -> firewall { '005 - IPv6: drop invalid state packets':
    state    => ['INVALID'],
    action   => 'drop',
    provider => 'ip6tables',
  }
  -> firewall { '006 - IPv6: enable logging':
    ensure     => absent,
    chain      => 'INPUT',
    proto      => 'all',
    jump       => 'LOG',
    log_prefix => 'iptables: ',
    provider   => 'ip6tables',
  }
  -> firewall { '100 - IPv6: log all packages':
    chain      => 'LOGGING',
    jump       => 'LOG',
    log_prefix => 'IPTables-Dropped: ',
    log_level  => '4',
    provider   => 'ip6tables',
  }
  -> firewall { '101 - IPv6: drop all received packages':
    chain    => 'LOGGING',
    proto    => 'all',
    action   => 'drop',
    provider => 'ip6tables',
    before   => undef,
  }
}
