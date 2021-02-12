# @summary
#   Manages firewall rules for IPv4 after all system specific rules are applied
#
class profile::firewall::post_ipv4 (
  Boolean $enable_logging = $profile::firewall::enable_logging,
) {
  if $enable_logging {
    firewall { '999 IPv4 log all other requests':
      proto  => 'all',
      jump   => 'LOGGING',
      before => undef,
    }
  } else {
    firewall { '999 - IPv4: drop all other requests':
      proto  => 'all',
      action => 'drop',
      before => undef,
    }
  }
}
