# @summary
#   Manages the basic firewall configuration for IPv4, before system specific rules are applied
#
# @param forward_policy
#   Policy for forwarding table
#
# @param ignore_rules
#   List of rules to ignore when purging
#
class profile::firewall::pre_ipv4 (
  Enum['accept', 'drop'] $forward_policy = $profile::firewall::forward_policy,
  Array $ignore_rules    = $profile::firewall::ignore_rules,
) {
  # Default policy for chains
  firewallchain { 'INPUT:filter:IPv4':
    ensure => present,
    purge  => true,
    policy => drop,
    ignore => $ignore_rules,
  }

  firewallchain { 'OUTPUT:filter:IPv4':
    ensure => present,
    purge  => true,
    policy => accept,
    ignore => $ignore_rules,
  }

  firewallchain { 'OUTPUT:nat:IPv4':
    ensure => present,
    purge  => true,
    policy => accept,
    ignore => $ignore_rules,
  }

  firewallchain { 'PREROUTING:nat:IPv4':
    ensure => present,
    purge  => true,
    policy => accept,
    ignore => $ignore_rules,
  }

  firewallchain { 'POSTROUTING:nat:IPv4':
    ensure => present,
    purge  => true,
    policy => accept,
    ignore => $ignore_rules,
  }

  firewallchain { 'FORWARD:filter:IPv4':
    ensure => present,
    purge  => true,
    policy => $forward_policy,
    ignore => $ignore_rules,
  }

  firewallchain { 'LOGGING:filter:IPv4':
    ensure => present,
    purge  => true,
  }

  # Sane Default Rules that are always applied first
  firewall { '000 - IPv4: accept all ICMP':
    proto  => 'icmp',
    action => 'accept',
  }
  -> firewall { '001 - IPv4: accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }
  -> firewall { '002 - IPv4: accept all docker0':
    iniface => 'docker0',
    action  => 'accept',
  }
  -> firewall { '003 - IPv4: reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    action      => 'reject',
  }
  -> firewall { '004 - IPv4: accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }
  -> firewall { '005 - IPv4: drop invalid state packets':
    state  => ['INVALID'],
    action => 'drop',
  }
  -> firewall { '006 - IPv4: enable logging':
    ensure     => absent,
    chain      => 'INPUT',
    proto      => 'all',
    jump       => 'LOG',
    log_prefix => 'iptables: ',
  }
  -> firewall { '100 - IPv4: log all packages':
    chain      => 'LOGGING',
    jump       => 'LOG',
    proto      => 'all',
    log_prefix => 'IPTables-Dropped: ',
    log_level  => '4',
  }
  -> firewall { '101 - IPv4:  drop all received packages':
    chain  => 'LOGGING',
    proto  => 'all',
    action => 'drop',
    before => undef,
  }
}
